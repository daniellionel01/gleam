use super::{src_span_to_lsp_range, uri_to_module_name, LspProjectCompiler};
use crate::{fs::ProjectIO, lsp::COMPILING_PROGRESS_TOKEN};
use gleam_core::diagnostic::Diagnostic;
use gleam_core::Warning;
use gleam_core::{ast::Import, io::FileSystemReader, language_server::FileSystemProxy};
use gleam_core::{
    ast::Statement,
    build::{Located, Module},
    config::PackageConfig,
    line_numbers::LineNumbers,
    type_::pretty::Printer,
    Error, Result,
};
use itertools::Itertools;
use lsp::DidOpenTextDocumentParams;
use lsp_types::{
    self as lsp, DidChangeTextDocumentParams, DidCloseTextDocumentParams,
    DidSaveTextDocumentParams, Hover, HoverContents, MarkedString, Position, Range, TextEdit, Url,
};
use std::path::{Path, PathBuf};

pub struct LanguageServer {
    /// A cached copy of the absolute path of the project root
    project_root: PathBuf,

    /// A compiler for the project that supports repeat compilation of the root
    /// package.
    /// In the event the the project config changes this will need to be
    /// discarded and reloaded to handle any changes to dependencies.
    compiler: Option<LspProjectCompiler<FileSystemProxy<ProjectIO>>>,

    fs_proxy: FileSystemProxy<ProjectIO>,

    config: Option<PackageConfig>,
}

impl LanguageServer {
    pub fn new(config: Option<PackageConfig>) -> Result<Self> {
        let project_root = std::env::current_dir().expect("Project root");
        let mut language_server = Self {
            project_root,
            compiler: None,
            fs_proxy: FileSystemProxy::new(ProjectIO::new()),
            config,
        };
        language_server.create_new_compiler()?;
        Ok(language_server)
    }

    fn notify_client_of_compilation_start(&self, connection: &lsp_server::Connection) {
        self.send_work_done_notification(
            connection,
            lsp::WorkDoneProgress::Begin(lsp::WorkDoneProgressBegin {
                title: "Compiling Gleam".into(),
                cancellable: Some(false),
                message: None,
                percentage: None,
            }),
        );
    }

    fn notify_client_of_compilation_end(&self, connection: &lsp_server::Connection) {
        self.send_work_done_notification(
            connection,
            lsp::WorkDoneProgress::End(lsp::WorkDoneProgressEnd { message: None }),
        );
    }

    fn send_work_done_notification(
        &self,
        connection: &lsp_server::Connection,
        work_done: lsp::WorkDoneProgress,
    ) {
        tracing::info!("sending {:?}", work_done);
        let params = lsp::ProgressParams {
            token: lsp::NumberOrString::String(COMPILING_PROGRESS_TOKEN.to_string()),
            value: lsp::ProgressParamsValue::WorkDone(work_done),
        };
        let notification = lsp_server::Notification {
            method: "$/progress".into(),
            params: serde_json::to_value(&params).expect("ProgressParams json"),
        };
        connection
            .sender
            .send(lsp_server::Message::Notification(notification))
            .expect("send_work_done_notification send")
    }

    /// Compile the project if we are in one. Otherwise do nothing.
    pub fn compile(&mut self, connection: &lsp_server::Connection) -> Result<(), Error> {
        self.notify_client_of_compilation_start(connection);
        let result = match self.compiler.as_mut() {
            Some(compiler) => compiler.compile(),
            None => Ok(()),
        };
        self.notify_client_of_compilation_end(connection);
        result
    }

    pub fn take_warnings(&mut self) -> Vec<Diagnostic> {
        if let Some(compiler) = self.compiler.as_mut() {
            compiler
                .warnings
                .take()
                .iter()
                .map(Warning::to_diagnostic)
                .collect_vec()
        } else {
            vec![]
        }
    }

    pub fn create_new_compiler(&mut self) -> Result<(), Error> {
        if let Some(config) = self.config.as_ref() {
            let compiler = LspProjectCompiler::new(config.clone(), self.fs_proxy.clone())?;
            self.compiler = Some(compiler);
        }
        Ok(())
    }

    pub fn text_document_did_open(
        &mut self,
        params: DidOpenTextDocumentParams,
        connection: &lsp_server::Connection,
    ) -> Result<()> {
        // A file opened in the editor which might be unsaved so store a copy of the new content in memory and compile
        let path = params.text_document.uri.path().to_string();
        self.fs_proxy
            .write_mem_cache(Path::new(path.as_str()), &params.text_document.text)?;
        self.compile(connection)?;
        Ok(())
    }

    pub fn text_document_did_save(
        &mut self,
        params: DidSaveTextDocumentParams,
        connection: &lsp_server::Connection,
    ) -> Result<()> {
        // The file is in sync with the file system, discard our cache of the changes
        self.fs_proxy
            .delete_mem_cache(Path::new(params.text_document.uri.path()))?;
        // The files on disc have changed, so compile the project with the new changes
        self.compile(connection)?;
        Ok(())
    }

    pub fn text_document_did_close(&mut self, params: DidCloseTextDocumentParams) -> Result<()> {
        // The file is in sync with the file system, discard our cache of the changes
        self.fs_proxy
            .delete_mem_cache(Path::new(params.text_document.uri.path()))?;
        Ok(())
    }

    pub fn text_document_did_change(
        &mut self,
        params: DidChangeTextDocumentParams,
        connection: &lsp_server::Connection,
    ) -> Result<()> {
        // A file has changed in the editor so store a copy of the new content in memory and compile
        let path = params.text_document.uri.path().to_string();
        if let Some(changes) = params.content_changes.into_iter().next() {
            self.fs_proxy
                .write_mem_cache(Path::new(path.as_str()), changes.text.as_str())?;
            self.compile(connection)?;
        }
        Ok(())
    }

    // TODO: test local variables
    // TODO: test same module constants
    // TODO: test imported module constants
    // TODO: test unqualified imported module constants
    // TODO: test same module records
    // TODO: test imported module records
    // TODO: test unqualified imported module records
    // TODO: test same module functions
    // TODO: test module function calls
    // TODO: test different package module function calls
    //
    //
    //
    // TODO: implement unqualified imported module functions
    // TODO: implement goto definition of modules that do not belong to the top
    // level package.
    //
    pub fn goto_definition(
        &self,
        params: lsp::GotoDefinitionParams,
    ) -> Result<Option<lsp::Location>> {
        let params = params.text_document_position_params;
        let (line_numbers, node) = match self.node_at_position(&params) {
            Some(location) => location,
            None => return Ok(None),
        };

        let location = match node.definition_location() {
            Some(location) => location,
            None => return Ok(None),
        };

        let (uri, line_numbers) = match location.module {
            None => (params.text_document.uri, &line_numbers),
            Some(name) => {
                let module = match self
                    .compiler
                    .as_ref()
                    .and_then(|compiler| compiler.sources.get(name))
                {
                    Some(module) => module,
                    // TODO: support goto definition for functions defined in
                    // different packages. Currently it is not possible as the
                    // required LineNumbers and source file path information is
                    // not stored in the module metadata.
                    None => return Ok(None),
                };
                let url = Url::parse(&format!("file:///{}", &module.path))
                    .expect("goto definition URL parse");
                (url, &module.line_numbers)
            }
        };
        let range = src_span_to_lsp_range(location.span, line_numbers);

        Ok(Some(lsp::Location { uri, range }))
    }

    // TODO: function & constructor labels
    // TODO: module types (including private)
    // TODO: module values (including private)
    // TODO: locally defined variables
    // TODO: imported module values
    // TODO: imported module types
    // TODO: record accessors
    pub fn completion(&self, params: lsp::CompletionParams) -> Option<Vec<lsp::CompletionItem>> {
        let found = self
            .node_at_position(&params.text_document_position)
            .map(|(_, found)| found);

        match found {
            // TODO: test
            None | Some(Located::Statement(Statement::Import(Import { .. }))) => {
                self.completion_for_import()
            }

            // TODO: autocompletion for other statements
            Some(Located::Statement(_expression)) => None,

            // TODO: autocompletion for expressions
            Some(Located::Expression(_expression)) => None,
        }
    }

    pub fn format(&self, params: lsp::DocumentFormattingParams) -> Result<Vec<TextEdit>> {
        let path = params.text_document.uri.path();
        let mut new_text = String::new();

        let src = self.fs_proxy.read(Path::new(path))?.into();
        gleam_core::format::pretty(&mut new_text, &src, Path::new(path))?;
        let line_count = src.lines().count() as u32;

        let edit = TextEdit {
            range: Range {
                start: Position {
                    line: 0,
                    character: 0,
                },
                end: Position {
                    line: line_count,
                    character: 0,
                },
            },
            new_text,
        };
        Ok(vec![edit])
    }

    fn completion_for_import(&self) -> Option<Vec<lsp::CompletionItem>> {
        let compiler = self.compiler.as_ref()?;
        // TODO: Test
        let dependencies_modules = compiler
            .project_compiler
            .get_importable_modules()
            .keys()
            .map(|name| name.to_string());
        // TODO: Test
        let project_modules = compiler
            .modules
            .iter()
            // TODO: We should autocomplete test modules if we are in the test dir
            // TODO: Test
            .filter(|(_name, module)| module.origin.is_src())
            .map(|(name, _module)| name)
            .cloned();
        let modules = dependencies_modules
            .chain(project_modules)
            .map(|label| lsp::CompletionItem {
                label,
                kind: None,
                documentation: None,
                ..Default::default()
            })
            .collect();
        Some(modules)
    }

    pub fn hover(&self, params: lsp::HoverParams) -> Result<Option<Hover>> {
        let params = params.text_document_position_params;

        let (line_numbers, found) = match self.node_at_position(&params) {
            Some(value) => value,
            None => return Ok(None),
        };

        let expression = match found {
            Located::Expression(expression) => expression,
            Located::Statement(_) => return Ok(None),
        };

        // Show the type of the hovered node to the user
        let type_ = Printer::new().pretty_print(expression.type_().as_ref(), 0);
        let contents = format!(
            "```gleam
{type_}
```"
        );
        Ok(Some(Hover {
            contents: HoverContents::Scalar(MarkedString::String(contents)),
            range: Some(src_span_to_lsp_range(expression.location(), &line_numbers)),
        }))
    }

    fn node_at_position(
        &self,
        params: &lsp::TextDocumentPositionParams,
    ) -> Option<(LineNumbers, Located<'_>)> {
        let module = self.module_for_uri(&params.text_document.uri);
        let module = module?;
        let line_numbers = LineNumbers::new(&module.code);
        let byte_index = line_numbers.byte_index(params.position.line, params.position.character);
        let node = module.find_node(byte_index);
        let node = node?;
        Some((line_numbers, node))
    }

    fn module_for_uri(&self, uri: &Url) -> Option<&Module> {
        self.compiler.as_ref().and_then(|compiler| {
            let module_name =
                uri_to_module_name(uri, &self.project_root).expect("uri to module name");
            compiler.modules.get(&module_name)
        })
    }
}