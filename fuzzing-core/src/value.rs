// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

//! Structured values for differential oracle comparison.
//!
//! Parse each target's echo output into `Value`s and compare structurally.
//! Each target parser handles its own rendering differences.

use crate::generator::{BitSeg, Expr, Module, Stmt};
use gleam_core::build::Target;

/// A Gleam value as printed by `echo`.
///
/// Erlang and JavaScript render values differently. For example,
/// Erlang prints `<<1, 2>>` as `"\u{0001}\u{0002}"` while JavaScript
/// prints `<<1, 2>>`. Both parse to the same `Value`, so comparison is exact.
#[derive(Debug, Clone, PartialEq)]
pub enum Value {
    Nil,
    Bool(bool),
    Int(i64),
    Float(f64),
    String(String),
    BitArray(Vec<u8>),
    List(Vec<Value>),
    Tuple(Vec<Value>),
    Constructor(String, Vec<Value>),
}

/// Convert a generator `Expr` to a `Value`.
///
/// Handles literal expressions only. The generator echoes literals,
/// not computed expressions.
pub fn expected_value(expr: &Expr) -> Option<Value> {
    match expr {
        Expr::IntLit(n) => Some(Value::Int(*n)),
        Expr::FloatLit(f) => Some(Value::Float(*f)),
        Expr::StrLit(s) => Some(Value::String(s.to_string())),
        Expr::BoolLit(b) => Some(Value::Bool(*b)),
        Expr::ListLit(xs) => {
            let vals: Option<Vec<Value>> = xs.iter().map(expected_value).collect();
            Some(Value::List(vals?))
        }
        Expr::TupLit(a, b) => {
            let va = expected_value(a)?;
            let vb = expected_value(b)?;
            Some(Value::Tuple(vec![va, vb]))
        }
        Expr::BitsLit(segs) => {
            let mut bytes = Vec::new();
            for seg in segs {
                match seg {
                    BitSeg::Int(val, _width) => {
                        bytes.push(*val as u8);
                    }
                    BitSeg::Utf8(s) => {
                        bytes.extend_from_slice(s.as_bytes());
                    }
                }
            }
            Some(Value::BitArray(bytes))
        }
        Expr::NegInt(e) => {
            let v = expected_value(e)?;
            match v {
                Value::Int(n) => Some(Value::Int(-n)),
                _ => None,
            }
        }
        // Other expressions are computed, not echoed directly.
        _ => None,
    }
}

/// Extract the expected output values from a Module.
pub fn expected_output(module: &Module) -> Vec<Value> {
    module
        .main_stmts()
        .iter()
        .filter_map(|stmt| match stmt {
            Stmt::Echo(expr) => expected_value(expr),
            _ => None,
        })
        .collect()
}

// ---------------------------------------------------------------------------
// Parse output into Values
// ---------------------------------------------------------------------------

/// Parse one line of echo output into a `Value`.
///
/// Each target has its own parser because Erlang and JavaScript render
/// values differently. Both produce the same `Value` type.
pub fn parse_value(line: &str, target: Target) -> Option<Value> {
    let line = line.trim();
    if line.is_empty() {
        return None;
    }
    match target {
        Target::Erlang => parse_erlang(line),
        Target::JavaScript => parse_javascript(line),
    }
}

/// Parse all output lines from a target into `Value`s.
/// Strips build noise before parsing.
pub fn parse_output(raw: &str, target: Target) -> Vec<Value> {
    let stripped = strip_build_noise(raw);
    stripped
        .lines()
        .filter_map(|line| parse_value(line, target))
        .collect()
}

/// Strip build noise from raw output.
/// Removes ANSI codes, warnings, source locations, and progress lines.
///
/// ANSI regex from <https://github.com/chalk/ansi-regex/blob/main/index.js>
/// License: MIT (CC0 for the regex itself)
pub fn strip_build_noise(raw: &str) -> String {
    // ansi-regex v6.0.1 from chalk/ansi-regex (MIT)
    // Matches: OSC sequences, CSI sequences, and other ANSI escape codes
    let ansi_re = regex::Regex::new(
        r"(?:\x07|\x1b\\|\x9c)|(?:\x1b\][^\x07\x1b\x9c]*(?:\x07|\x1b\\|\x9c))|[\x1b\x9b][\[\]()*#;?]*(?:\d{1,4}(?:[;:]\d{0,4})*)?[\dA-PR-TZcf-nq-uy=><~]"
    )
    .unwrap();
    let source_loc_re = regex::Regex::new(r"main\.gleam:\d+").unwrap();
    let progress_re = regex::Regex::new(
        r"^(Resolving versions|Compiling |Compiled in |Running |Downloading |Added |Downloaded )",
    )
    .unwrap();
    let hint_re = regex::Regex::new(r"^(Hint:|warning:|error:)").unwrap();
    let warning_context_re = regex::Regex::new(
        r"^(This segment|be truncated|resulting in|The |^It |\^|This pattern|Matching on|unreachable|redundant)",
    )
    .unwrap();

    let mut result = String::new();
    let mut in_warning = false;
    let mut in_warning_block = false;

    for line in raw.lines() {
        let stripped = ansi_re.replace_all(line, "");
        let trimmed = stripped.trim();

        // Skip empty lines
        if trimmed.is_empty() {
            in_warning = false;
            in_warning_block = false;
            continue;
        }

        // Handle warning blocks
        if in_warning {
            continue;
        }
        if trimmed.starts_with("warning:") {
            in_warning = true;
            continue;
        }

        // Handle warning context (indented lines after warning details)
        if in_warning_block {
            if trimmed.starts_with("Hint:") || trimmed.starts_with("error:") {
                in_warning_block = false;
            } else {
                continue;
            }
        }
        if warning_context_re.is_match(trimmed) {
            in_warning_block = true;
            continue;
        }

        // Skip source location lines
        if source_loc_re.is_match(trimmed) {
            continue;
        }

        // Skip progress and hint lines
        if progress_re.is_match(trimmed) || hint_re.is_match(trimmed) {
            continue;
        }

        // Skip lines that look like compiler error context (indented, no value shape)
        if trimmed.starts_with('|') || trimmed.starts_with("^") || trimmed.starts_with("--") {
            continue;
        }

        result.push_str(trimmed);
        result.push('\n');
    }
    result
}

// ---------------------------------------------------------------------------
// Erlang parser
//
// Erlang echo@inspect renders:
//   nil       -> "Nil"
//   true      -> "True"
//   false     -> "False"
//   int       -> integer literal (e.g. "42", "-1")
//   float     -> float literal (e.g. "1.0", "-3.14", "1.0e6")
//   binary    -> "string" (UTF-8) or <<bytes>> (non-UTF-8)
//   bitarray  -> "string" (valid UTF-8) or <<bytes>> (non-UTF-8)
//   atom      -> Constructor
//   list      -> [elements]
//   tuple     -> #(elements)
//   record    -> Constructor(fields)
// ---------------------------------------------------------------------------

fn parse_erlang(line: &str) -> Option<Value> {
    let line = line.trim();
    match line {
        "Nil" => return Some(Value::Nil),
        "True" => return Some(Value::Bool(true)),
        "False" => return Some(Value::Bool(false)),
        _ => {}
    }

    // Integer
    if let Ok(n) = line.parse::<i64>() {
        return Some(Value::Int(n));
    }

    // Float
    if let Ok(f) = parse_erlang_float(line) {
        return Some(Value::Float(f));
    }

    // String (starts and ends with ")
    if line.starts_with('"') && line.ends_with('"') {
        let inner = &line[1..line.len() - 1];
        return Some(Value::String(unescape_erlang_string(inner)));
    }

    // Bit array: <<...>>
    if line.starts_with("<<") && line.ends_with(">>") {
        let inner = &line[2..line.len() - 2];
        let bytes = parse_erlang_bit_array(inner);
        return Some(Value::BitArray(bytes));
    }

    // List: [...]
    if line.starts_with('[') && line.ends_with(']') {
        let inner = &line[1..line.len() - 1];
        let items = split_erlang_items(inner);
        let vals: Vec<Value> = items.iter().filter_map(|s| parse_erlang(s)).collect();
        return Some(Value::List(vals));
    }

    // Tuple: #(...)
    if line.starts_with("#(") && line.ends_with(')') {
        let inner = &line[2..line.len() - 1];
        let items = split_erlang_items(inner);
        let vals: Vec<Value> = items.iter().filter_map(|s| parse_erlang(s)).collect();
        return Some(Value::Tuple(vals));
    }

    // Constructor: Name or Name(args)
    if let Some(v) = parse_erlang_constructor(line) {
        return Some(v);
    }

    None
}

fn parse_erlang_float(line: &str) -> Result<f64, ()> {
    // Handle scientific notation: 1.0e6, -3.14e2
    if line.contains('e') || line.contains('E') {
        line.parse::<f64>().map_err(|_| ())
    } else if line.contains('.') {
        line.parse::<f64>().map_err(|_| ())
    } else {
        Err(())
    }
}

fn unescape_erlang_string(s: &str) -> String {
    let mut result = String::new();
    let mut chars = s.chars().peekable();
    while let Some(c) = chars.next() {
        if c == '\\' {
            match chars.next() {
                Some('n') => result.push('\n'),
                Some('r') => result.push('\r'),
                Some('t') => result.push('\t'),
                Some('\\') => result.push('\\'),
                Some('"') => result.push('"'),
                Some('u') => {
                    // \u{XXXX}
                    if chars.peek() == Some(&'{') {
                        chars.next(); // consume '{'
                        let hex: String = chars.by_ref().take_while(|c| *c != '}').collect();
                        if let Ok(code) = u32::from_str_radix(&hex, 16) {
                            if let Some(ch) = char::from_u32(code) {
                                result.push(ch);
                            }
                        }
                    }
                }
                Some(c) => {
                    result.push('\\');
                    result.push(c);
                }
                None => {}
            }
        } else {
            result.push(c);
        }
    }
    result
}

fn parse_erlang_bit_array(inner: &str) -> Vec<u8> {
    if inner.is_empty() {
        return Vec::new();
    }
    let mut bytes = Vec::new();
    for part in inner.split(", ") {
        let part = part.trim();
        // Handle "value:size(N)" segments
        if let Some(pos) = part.find(":size(") {
            let val_str = &part[..pos];
            if let Ok(val) = val_str.parse::<u8>() {
                bytes.push(val);
            }
        } else if let Ok(val) = part.parse::<u8>() {
            bytes.push(val);
        }
    }
    bytes
}

fn split_erlang_items(s: &str) -> Vec<String> {
    if s.is_empty() {
        return Vec::new();
    }
    let mut items = Vec::new();
    let mut depth = 0;
    let mut current = String::new();
    let mut in_string = false;
    let mut chars = s.chars().peekable();

    while let Some(c) = chars.next() {
        match c {
            '"' if !in_string => {
                in_string = true;
                current.push(c);
            }
            '"' if in_string => {
                in_string = false;
                current.push(c);
            }
            '\\' if in_string => {
                current.push(c);
                if let Some(next) = chars.next() {
                    current.push(next);
                }
            }
            _ if in_string => {
                current.push(c);
            }
            '(' | '[' | '{' => {
                depth += 1;
                current.push(c);
            }
            ')' | ']' | '}' => {
                depth -= 1;
                current.push(c);
            }
            '#' => {
                // # is part of tuple syntax #( but doesn't increment depth
                current.push(c);
            }
            ',' if depth == 0 => {
                items.push(current.trim().to_string());
                current = String::new();
            }
            _ => {
                current.push(c);
            }
        }
    }
    if !current.trim().is_empty() {
        items.push(current.trim().to_string());
    }
    items
}

fn parse_erlang_constructor(line: &str) -> Option<Value> {
    // Constructor with args: Name(arg1, arg2, ...)
    if let Some(paren_pos) = line.find('(') {
        if line.ends_with(')') {
            let name = line[..paren_pos].to_string();
            let inner = &line[paren_pos + 1..line.len() - 1];
            let items = split_erlang_items(inner);
            let vals: Vec<Value> = items.iter().filter_map(|s| parse_erlang(s)).collect();
            return Some(Value::Constructor(name, vals));
        }
    }
    // Simple constructor: Name
    let name = line.to_string();
    if name.chars().next().map_or(false, |c| c.is_uppercase()) {
        return Some(Value::Constructor(name, Vec::new()));
    }
    None
}

// ---------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// JavaScript parser
//
// JavaScript echo@inspect renders:
//   undefined -> "Nil"
//   true      -> "True"
//   false     -> "False"
//   int       -> integer literal
//   float     -> float literal (e.g. "1", "3.14", "1e6")
//   string    -> "string"
//   bitarray  -> <<bytes>>
//   array     -> #(elements) (JS arrays)
//   list      -> [elements] (Gleam lists)
//   record    -> Constructor(fields)
//   tuple     -> #(elements) (JS tuples)
// ---------------------------------------------------------------------------

fn parse_javascript(line: &str) -> Option<Value> {
    let line = line.trim();
    match line {
        "Nil" => return Some(Value::Nil),
        "True" => return Some(Value::Bool(true)),
        "False" => return Some(Value::Bool(false)),
        _ => {}
    }

    // Integer
    if let Ok(n) = line.parse::<i64>() {
        return Some(Value::Int(n));
    }

    // Float (JavaScript doesn't print .0 for whole numbers)
    if let Ok(f) = line.parse::<f64>() {
        return Some(Value::Float(f));
    }

    // String
    if line.starts_with('"') && line.ends_with('"') {
        let inner = &line[1..line.len() - 1];
        return Some(Value::String(unescape_javascript_string(inner)));
    }

    // Bit array: <<...>>
    if line.starts_with("<<") && line.ends_with(">>") {
        let inner = &line[2..line.len() - 2];
        let bytes = parse_javascript_bit_array(inner);
        return Some(Value::BitArray(bytes));
    }

    // Tuple: #(elements)
    if line.starts_with("#(") && line.ends_with(')') {
        let inner = &line[2..line.len() - 1];
        let items = split_javascript_items(inner);
        let vals: Vec<Value> = items.iter().filter_map(|s| parse_javascript(s)).collect();
        return Some(Value::Tuple(vals));
    }

    // List: [elements]
    if line.starts_with('[') && line.ends_with(']') {
        let inner = &line[1..line.len() - 1];
        let items = split_javascript_items(inner);
        let vals: Vec<Value> = items.iter().filter_map(|s| parse_javascript(s)).collect();
        return Some(Value::List(vals));
    }

    // Constructor: Name or Name(args)
    if let Some(v) = parse_javascript_constructor(line) {
        return Some(v);
    }

    None
}

fn unescape_javascript_string(s: &str) -> String {
    let mut result = String::new();
    let mut chars = s.chars();
    while let Some(c) = chars.next() {
        if c == '\\' {
            match chars.next() {
                Some('n') => result.push('\n'),
                Some('r') => result.push('\r'),
                Some('t') => result.push('\t'),
                Some('\\') => result.push('\\'),
                Some('"') => result.push('"'),
                Some('u') => {
                    // \u{XXXX}
                    let hex: String = chars.by_ref().take_while(|c| *c != '}').collect();
                    if let Ok(code) = u32::from_str_radix(&hex, 16) {
                        if let Some(ch) = char::from_u32(code) {
                            result.push(ch);
                        }
                    }
                }
                Some(c) => {
                    result.push('\\');
                    result.push(c);
                }
                None => {}
            }
        } else {
            result.push(c);
        }
    }
    result
}

fn parse_javascript_bit_array(inner: &str) -> Vec<u8> {
    if inner.is_empty() {
        return Vec::new();
    }
    let mut bytes = Vec::new();
    for part in inner.split(", ") {
        let part = part.trim();
        // Handle "value:size(N)" segments
        if let Some(pos) = part.find(":size(") {
            let val_str = &part[..pos];
            if let Ok(val) = val_str.parse::<u8>() {
                bytes.push(val);
            }
        } else if let Ok(val) = part.parse::<u8>() {
            bytes.push(val);
        }
    }
    bytes
}

fn split_javascript_items(s: &str) -> Vec<String> {
    if s.is_empty() {
        return Vec::new();
    }
    let mut items = Vec::new();
    let mut depth = 0;
    let mut current = String::new();
    let mut in_string = false;
    let mut chars = s.chars().peekable();

    while let Some(c) = chars.next() {
        match c {
            '"' if !in_string => {
                in_string = true;
                current.push(c);
            }
            '"' if in_string => {
                in_string = false;
                current.push(c);
            }
            '\\' if in_string => {
                current.push(c);
                if let Some(next) = chars.next() {
                    current.push(next);
                }
            }
            _ if in_string => {
                current.push(c);
            }
            '(' | '[' | '{' => {
                depth += 1;
                current.push(c);
            }
            ')' | ']' | '}' => {
                depth -= 1;
                current.push(c);
            }
            '#' => {
                // # is part of tuple syntax #( but doesn't increment depth
                current.push(c);
            }
            ',' if depth == 0 => {
                items.push(current.trim().to_string());
                current = String::new();
            }
            _ => {
                current.push(c);
            }
        }
    }
    if !current.trim().is_empty() {
        items.push(current.trim().to_string());
    }
    items
}

fn parse_javascript_constructor(line: &str) -> Option<Value> {
    // Constructor with args: Name(arg1, arg2, ...)
    if let Some(paren_pos) = line.find('(') {
        if line.ends_with(')') {
            let name = line[..paren_pos].to_string();
            let inner = &line[paren_pos + 1..line.len() - 1];
            let items = split_javascript_items(inner);
            let vals: Vec<Value> = items.iter().filter_map(|s| parse_javascript(s)).collect();
            return Some(Value::Constructor(name, vals));
        }
    }
    // Simple constructor: Name
    let name = line.to_string();
    if name.chars().next().map_or(false, |c| c.is_uppercase()) {
        return Some(Value::Constructor(name, Vec::new()));
    }
    None
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

#[cfg(test)]
mod tests {
    use super::*;

    // ----- expected_value tests -----

    #[test]
    fn expected_int() {
        let expr = Expr::IntLit(42);
        assert_eq!(expected_value(&expr), Some(Value::Int(42)));
    }

    #[test]
    fn expected_negative_int() {
        let expr = Expr::NegInt(Box::new(Expr::IntLit(42)));
        assert_eq!(expected_value(&expr), Some(Value::Int(-42)));
    }

    #[test]
    fn expected_float() {
        let expr = Expr::FloatLit(3.14);
        assert_eq!(expected_value(&expr), Some(Value::Float(3.14)));
    }

    #[test]
    fn expected_string() {
        let expr = Expr::StrLit("hello");
        assert_eq!(expected_value(&expr), Some(Value::String("hello".into())));
    }

    #[test]
    fn expected_bool() {
        assert_eq!(expected_value(&Expr::BoolLit(true)), Some(Value::Bool(true)));
        assert_eq!(expected_value(&Expr::BoolLit(false)), Some(Value::Bool(false)));
    }

    #[test]
    fn expected_list() {
        let expr = Expr::ListLit(vec![Expr::IntLit(1), Expr::IntLit(2), Expr::IntLit(3)]);
        assert_eq!(
            expected_value(&expr),
            Some(Value::List(vec![Value::Int(1), Value::Int(2), Value::Int(3)]))
        );
    }

    #[test]
    fn expected_tuple() {
        let expr = Expr::TupLit(
            Box::new(Expr::IntLit(1)),
            Box::new(Expr::StrLit("two")),
        );
        assert_eq!(
            expected_value(&expr),
            Some(Value::Tuple(vec![Value::Int(1), Value::String("two".into())]))
        );
    }

    #[test]
    fn expected_bit_array() {
        let expr = Expr::BitsLit(vec![BitSeg::Int(1, 8), BitSeg::Int(2, 8), BitSeg::Int(3, 8)]);
        assert_eq!(
            expected_value(&expr),
            Some(Value::BitArray(vec![1, 2, 3]))
        );
    }

    #[test]
    fn expected_bit_array_utf8() {
        let expr = Expr::BitsLit(vec![BitSeg::Utf8("hello")]);
        assert_eq!(
            expected_value(&expr),
            Some(Value::BitArray(vec![104, 101, 108, 108, 111]))
        );
    }

    #[test]
    fn expected_empty_bit_array() {
        let expr = Expr::BitsLit(vec![]);
        assert_eq!(expected_value(&expr), Some(Value::BitArray(vec![])));
    }

    // ----- Erlang parser tests -----

    #[test]
    fn parse_erlang_int() {
        assert_eq!(parse_erlang("42"), Some(Value::Int(42)));
        assert_eq!(parse_erlang("-1"), Some(Value::Int(-1)));
        assert_eq!(parse_erlang("0"), Some(Value::Int(0)));
    }

    #[test]
    fn parse_erlang_float() {
        assert_eq!(parse_erlang("1.0"), Some(Value::Float(1.0)));
        assert_eq!(parse_erlang("-3.14"), Some(Value::Float(-3.14)));
        assert_eq!(parse_erlang("0.0"), Some(Value::Float(0.0)));
        assert_eq!(parse_erlang("1.0e6"), Some(Value::Float(1_000_000.0)));
    }

    #[test]
    fn parse_erlang_string() {
        assert_eq!(parse_erlang("\"hello\""), Some(Value::String("hello".into())));
        assert_eq!(parse_erlang("\"\""), Some(Value::String("".into())));
        assert_eq!(
            parse_erlang("\"line1\\nline2\""),
            Some(Value::String("line1\nline2".into()))
        );
    }

    #[test]
    fn parse_erlang_bool() {
        assert_eq!(parse_erlang("True"), Some(Value::Bool(true)));
        assert_eq!(parse_erlang("False"), Some(Value::Bool(false)));
    }

    #[test]
    fn parse_erlang_nil() {
        assert_eq!(parse_erlang("Nil"), Some(Value::Nil));
    }

    #[test]
    fn parse_erlang_list() {
        assert_eq!(
            parse_erlang("[1, 2, 3]"),
            Some(Value::List(vec![Value::Int(1), Value::Int(2), Value::Int(3)]))
        );
        assert_eq!(parse_erlang("[]"), Some(Value::List(vec![])));
    }

    #[test]
    fn parse_erlang_tuple() {
        assert_eq!(
            parse_erlang("#(1, \"two\")"),
            Some(Value::Tuple(vec![Value::Int(1), Value::String("two".into())]))
        );
    }

    #[test]
    fn parse_erlang_bit_array() {
        assert_eq!(
            parse_erlang("<<1, 2, 3>>"),
            Some(Value::BitArray(vec![1, 2, 3]))
        );
        assert_eq!(parse_erlang("<<>>"), Some(Value::BitArray(vec![])));
    }

    #[test]
    fn parse_erlang_utf8_string_as_bit_array() {
        assert_eq!(
            parse_erlang("\"\\u{0001}\\u{0002}\\u{0003}\""),
            Some(Value::String("\u{0001}\u{0002}\u{0003}".into()))
        );
    }

    #[test]
    fn parse_erlang_constructor() {
        assert_eq!(
            parse_erlang("Ok(1)"),
            Some(Value::Constructor("Ok".into(), vec![Value::Int(1)]))
        );
        assert_eq!(
            parse_erlang("Red"),
            Some(Value::Constructor("Red".into(), vec![]))
        );
    }

    #[test]
    fn parse_erlang_nested() {
        assert_eq!(
            parse_erlang("[Ok(1), Error(\"boom\")]"),
            Some(Value::List(vec![
                Value::Constructor("Ok".into(), vec![Value::Int(1)]),
                Value::Constructor("Error".into(), vec![Value::String("boom".into())]),
            ]))
        );
    }

    // ----- JavaScript parser tests -----

    #[test]
    fn parse_javascript_int() {
        assert_eq!(parse_javascript("42"), Some(Value::Int(42)));
        assert_eq!(parse_javascript("-1"), Some(Value::Int(-1)));
    }

    #[test]
    fn parse_javascript_float() {
        assert_eq!(parse_javascript("1"), Some(Value::Int(1))); // JS doesn't print .0
        assert_eq!(parse_javascript("3.14"), Some(Value::Float(3.14)));
        assert_eq!(parse_javascript("1e6"), Some(Value::Float(1_000_000.0)));
    }

    #[test]
    fn parse_javascript_string() {
        assert_eq!(
            parse_javascript("\"hello\""),
            Some(Value::String("hello".into()))
        );
    }

    #[test]
    fn parse_javascript_bool() {
        assert_eq!(parse_javascript("True"), Some(Value::Bool(true)));
        assert_eq!(parse_javascript("False"), Some(Value::Bool(false)));
    }

    #[test]
    fn parse_javascript_nil() {
        assert_eq!(parse_javascript("Nil"), Some(Value::Nil));
    }

    #[test]
    fn parse_javascript_bit_array() {
        assert_eq!(
            parse_javascript("<<1, 2, 3>>"),
            Some(Value::BitArray(vec![1, 2, 3]))
        );
        assert_eq!(parse_javascript("<<>>"), Some(Value::BitArray(vec![])));
    }

    #[test]
    fn parse_javascript_tuple() {
        assert_eq!(
            parse_javascript("#(1, \"two\")"),
            Some(Value::Tuple(vec![Value::Int(1), Value::String("two".into())]))
        );
    }

    #[test]
    fn parse_javascript_constructor() {
        assert_eq!(
            parse_javascript("Ok(1)"),
            Some(Value::Constructor("Ok".into(), vec![Value::Int(1)]))
        );
        assert_eq!(
            parse_javascript("Red"),
            Some(Value::Constructor("Red".into(), vec![]))
        );
    }

    // ----- Cross-target equivalence tests -----
    // These verify that the same value parses to the same Value from both targets

    #[test]
    fn cross_target_int() {
        let erl = parse_erlang("42");
        let js = parse_javascript("42");
        assert_eq!(erl, js);
    }

    #[test]
    fn cross_target_bool() {
        let erl = parse_erlang("True");
        let js = parse_javascript("True");
        assert_eq!(erl, js);
    }

    #[test]
    fn cross_target_string() {
        let erl = parse_erlang("\"hello\"");
        let js = parse_javascript("\"hello\"");
        assert_eq!(erl, js);
    }

    #[test]
    fn cross_target_bit_array() {
        let erl = parse_erlang("<<1, 2, 3>>");
        let js = parse_javascript("<<1, 2, 3>>");
        assert_eq!(erl, js);
        assert_eq!(erl, Some(Value::BitArray(vec![1, 2, 3])));
    }

    #[test]
    fn cross_target_bit_array_from_utf8() {
        let erl = parse_erlang("\"\\u{0001}\\u{0002}\\u{0003}\"");
        let js = parse_javascript("<<1, 2, 3>>");
        assert_ne!(erl, js, "Erlang renders bit arrays as UTF-8 strings, JS as <<...>>");
    }

    #[test]
    fn cross_target_float() {
        let erl = parse_erlang("1.0");
        let js = parse_javascript("1");
        assert_eq!(erl, Some(Value::Float(1.0)));
        assert_eq!(js, Some(Value::Int(1)));
    }

    #[test]
    fn cross_target_list() {
        let erl = parse_erlang("[1, 2, 3]");
        let js = parse_javascript("[1, 2, 3]");
        assert_eq!(erl, js);
    }

    #[test]
    fn cross_target_constructor() {
        let erl = parse_erlang("Ok(1)");
        let js = parse_javascript("Ok(1)");
        assert_eq!(erl, js);
    }

    // ----- Empty and edge cases -----

    #[test]
    fn parse_empty_line() {
        assert_eq!(parse_erlang(""), None);
        assert_eq!(parse_javascript(""), None);
        assert_eq!(parse_erlang("  "), None);
    }

    #[test]
    fn parse_unknown_format() {
        assert_eq!(parse_erlang("some random text"), None);
        assert_eq!(parse_javascript("some random text"), None);
    }

    // ----- split_items tests -----

    #[test]
    fn split_items_empty() {
        assert_eq!(split_erlang_items(""), Vec::<String>::new());
    }

    #[test]
    fn split_items_simple() {
        assert_eq!(
            split_erlang_items("1, 2, 3"),
            vec!["1", "2", "3"]
        );
    }

    #[test]
    fn split_items_nested() {
        assert_eq!(
            split_erlang_items("#(1, 2), 3"),
            vec!["#(1, 2)", "3"]
        );
    }

    #[test]
    fn split_items_string() {
        assert_eq!(
            split_erlang_items("\"a, b\", 3"),
            vec!["\"a, b\"", "3"]
        );
    }
}

#[cfg(test)]
mod real_output_tests {
    use super::*;

    const ERLANG_RAW: &str = r#"  Resolving versions
Downloading packages
 Downloaded 1 package in 0.01s
      Added gleam_stdlib v1.0.5
  Compiling gleam_stdlib
  Compiling main
warning: Unused result value
  ┌─ /private/var/folders/.../src/main.gleam:8:3
  │
8 │   echo Ok(1)
  │   ^^^^^^^^^^ The Result value created here is unused

Hint: If you are sure you don't need it you can assign it to `_`.

   Compiled in 0.37s
    Running main.main
[90msrc/main.gleam:2[39m
42
[90msrc/main.gleam:3[39m
"hello"
[90msrc/main.gleam:4[39m
1.0
[90msrc/main.gleam:5[39m
"\u{0001}\u{0002}\u{0003}"
[90msrc/main.gleam:6[39m
[1, 2]
[90msrc/main.gleam:7[39m
#(1, "two")
[90msrc/main.gleam:8[39m
Ok(1)
[90msrc/main.gleam:9[39m
Red"#;

    const JAVASCRIPT_RAW: &str = r#"  Compiling gleam_stdlib
  Compiling main
warning: Unused result value
  ┌─ /private/var/folders/.../src/main.gleam:8:3
  │
8 │   echo Ok(1)
  │   ^^^^^^^^^^ The Result value created here is unused

Hint: If you are sure you don't need it you can assign it to `_`.

   Compiled in 0.04s
    Running main.main
[90msrc/main.gleam:2[39m
42
[90msrc/main.gleam:3[39m
"hello"
[90msrc/main.gleam:4[39m
1
[90msrc/main.gleam:5[39m
<<1, 2, 3>>
[90msrc/main.gleam:6[39m
[1, 2]
[90msrc/main.gleam:7[39m
#(1, "two")
[90msrc/main.gleam:8[39m
Ok(1)
[90msrc/main.gleam:9[39m
Red"#;

    #[test]
    fn strip_build_noise_real_erlang() {
        let stripped = strip_build_noise(ERLANG_RAW);
        assert!(!stripped.contains("Resolving versions"));
        assert!(!stripped.contains("Compiling"));
        assert!(!stripped.contains("warning:"));
        assert!(!stripped.contains("Hint:"));
        assert!(!stripped.contains("Compiled in"));
        assert!(stripped.contains("42"));
        assert!(stripped.contains("\"hello\""));
        assert!(stripped.contains("Red"));
    }

    #[test]
    fn strip_build_noise_real_javascript() {
        let stripped = strip_build_noise(JAVASCRIPT_RAW);
        assert!(!stripped.contains("Compiling"));
        assert!(!stripped.contains("warning:"));
        assert!(!stripped.contains("Hint:"));
        assert!(stripped.contains("42"));
        assert!(stripped.contains("\"hello\""));
        assert!(stripped.contains("Red"));
    }

    #[test]
    fn parse_real_erlang_output() {
        let values = parse_output(ERLANG_RAW, Target::Erlang);
        assert_eq!(values, vec![
            Value::Int(42),
            Value::String("hello".into()),
            Value::Float(1.0),
            Value::String("\u{1}\u{2}\u{3}".into()),
            Value::List(vec![Value::Int(1), Value::Int(2)]),
            Value::Tuple(vec![Value::Int(1), Value::String("two".into())]),
            Value::Constructor("Ok".into(), vec![Value::Int(1)]),
            Value::Constructor("Red".into(), vec![]),
        ]);
    }

    #[test]
    fn parse_real_javascript_output() {
        let values = parse_output(JAVASCRIPT_RAW, Target::JavaScript);
        assert_eq!(values, vec![
            Value::Int(42),
            Value::String("hello".into()),
            Value::Int(1),
            Value::BitArray(vec![1, 2, 3]),
            Value::List(vec![Value::Int(1), Value::Int(2)]),
            Value::Tuple(vec![Value::Int(1), Value::String("two".into())]),
            Value::Constructor("Ok".into(), vec![Value::Int(1)]),
            Value::Constructor("Red".into(), vec![]),
        ]);
    }

    #[test]
    fn cross_target_matches_except_known_divergences() {
        let erl = parse_output(ERLANG_RAW, Target::Erlang);
        let js = parse_output(JAVASCRIPT_RAW, Target::JavaScript);
        assert_eq!(erl.len(), js.len());
        for i in 0..erl.len() {
            if erl[i] != js[i] {
                match (&erl[i], &js[i]) {
                    (Value::Float(f), Value::Int(n)) => {
                        assert_eq!(*f, *n as f64, "float/int mismatch at index {i}");
                    }
                    (Value::String(s), Value::BitArray(bytes)) => {
                        assert_eq!(s.as_bytes(), bytes.as_slice(), "bit array mismatch at index {i}");
                    }
                    _ => panic!("unexpected difference at index {i}: {:?} vs {:?}", erl[i], js[i]),
                }
            }
        }
    }
}
