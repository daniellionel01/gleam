// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

//! gleam-smith: a deterministic, type-directed generator of well-typed
//! Gleam programs, in the tradition of Csmith and wasm-smith.
//!
//! Design contract (copied from wasm-smith):
//! - VALID BY CONSTRUCTION: generated programs parse and type check.
//!   Any exception is a *generator* bug, and the fuzz target for this
//!   crate panics on it so it cannot go unnoticed.
//! - DETERMINISTIC: `from_seed(n)` always yields the same program.
//! - FUEL-BOUNDED: depth/size budgets keep programs small (20-80 lines)
//!   and generation fast.
//! - PLAYS NICE WITH MUTATION: implements `arbitrary::Arbitrary`, so
//!   libFuzzer drives generation from raw bytes and small input changes
//!   produce small program changes.
//!
//! v1 deliberate scope (see redteam/README.md roadmap):
//! - types: Int, String, Bool, List(Int), 2-tuples, generated custom enums
//! - constructs: let bindings (with shadowing bias), blocks, case with
//!   1-2 subjects, alternatives, aliases, guards, string prefix patterns,
//!   pipelines, anonymous functions, terminating recursion helpers
//! - echo statements restricted to Int/String/Bool/List(Int) so that
//!   cross-target `echo` output is comparable (see the divergence spec)
//! - NOT in v1: floats, bit arrays, constants, imports, external fns,
//!   use expressions, todo/panic

use arbitrary::{Arbitrary, Result, Unstructured};

// ---------------------------------------------------------------------------
// Types

#[derive(Debug, Clone, PartialEq, Eq)]
enum Ty {
    Int,
    Str,
    Bool,
    ListInt,
    Tup(Box<Ty>, Box<Ty>),
    Custom(usize),
}

#[derive(Debug, Clone)]
struct Ctor {
    name: String,
    fields: Vec<(Option<String>, Ty)>,
}

#[derive(Debug, Clone)]
pub struct CustomType {
    name: String,
    ctors: Vec<Ctor>,
}

#[derive(Debug, Clone)]
struct FnSig {
    name: String,
    params: Vec<(String, Ty)>,
    ret: Ty,
}

// ---------------------------------------------------------------------------
// AST

#[derive(Debug, Clone)]
enum Expr {
    IntLit(i64),
    StrLit(&'static str),
    BoolLit(bool),
    Var(String),
    ListLit(Vec<Expr>),
    TupLit(Box<Expr>, Box<Expr>),
    Bin(BinOp, Box<Expr>, Box<Expr>),
    NegBool(Box<Expr>),
    NegInt(Box<Expr>),
    Case {
        subjs: Vec<Expr>,
        clauses: Vec<Clause>,
    },
    Block(Vec<(String, Expr)>, Box<Expr>),
    Call {
        name: String,
        args: Vec<Expr>,
    },
    Pipe {
        first: Box<Expr>,
        name: String,
        args: Vec<Expr>,
    },
    ApplyAnon {
        params: Vec<String>,
        body: Box<Expr>,
        args: Vec<Expr>,
    },
}

#[derive(Debug, Clone, Copy)]
enum BinOp {
    Add,
    Sub,
    Mul,
    Rem,
    Eq,
    Ne,
    Lt,
    Le,
    Gt,
    Ge,
    And,
    Or,
    Concat,
}

#[derive(Debug, Clone)]
struct Clause {
    pats: Vec<Pattern>,
    alts: Vec<Pattern>,
    guard: Option<Expr>,
    body: Expr,
}

#[derive(Debug, Clone)]
enum Pattern {
    Discard,
    Var(String),
    Alias(Box<Pattern>, String),
    IntLit(u32),
    StrLit(&'static str),
    BoolLit(bool),
    Prefix(&'static str, Option<String>),
    ListNil,
    ListCons {
        elems: Vec<Pattern>,
        rest: RestPat,
    },
    CtorPat {
        name: String,
        fields: Vec<Pattern>,
    },
    TupPat(Box<Pattern>, Box<Pattern>),
}

#[derive(Debug, Clone, PartialEq)]
enum RestPat {
    Closed,
    Open,
    Named(String),
}

#[derive(Debug, Clone)]
enum Stmt {
    Let(String, Expr),
    Echo(Expr),
}

#[derive(Debug, Clone)]
pub struct Module {
    types: Vec<CustomType>,
    helper: Option<&'static str>,
    functions: Vec<(FnSig, Expr)>,
    main: Vec<Stmt>,
}

// ---------------------------------------------------------------------------
// Name pools (hostile on purpose: JS/Erlang reserved words and prelude
// names, to exercise codegen hygiene — bug class 2 in redteam/README.md)

const VAR_POOL: &[&str] = &[
    "x", "y", "z", "n", "m", "s", "l", "rest", "value", "acc", "item", "pair", "v",
    "constructor", "arguments", "prototype", "class", "new", "delete", "default", "length",
    "self_", "this_",
];
const FN_HOSTILE: &[&str] = &[
    "delete", "new", "class", "default", "export", "extends", "static", "yield",
    "arguments", "constructor",
];
const TYPE_POOL: &[&str] = &["Number", "Record", "Promise", "Object", "Symbol", "Map"];
const CTOR_POOL: &[&str] = &["Ok", "Error", "Some", "None", "Number", "Record"];
const LABEL_POOL: &[&str] = &["value", "inner", "data", "constructor", "field"];
const STR_POOL: &[&str] = &["", "a", "ab", "abc", "b", "bc", "x", "data", "res", "constructor"];
const INT_POOL: &[i64] = &[0, 1, 2, 3, 4, 5, 7, 10, 42, 100];

/// F-10 (redteam/findings.md): immediately-applied anonymous functions
/// crash Erlang codegen when a parameter is referenced more than once.
/// Set to true once upstream fixes the bug — the shape is excellent
/// intended coverage.
const ANON_APPLY_ENABLED: bool = false;

// ---------------------------------------------------------------------------
// Generation context

type Env = Vec<(String, Ty)>;

/// Push a binding into the environment, respecting shadowing: a new binding
/// with the same name makes the old one inaccessible.
fn env_push(env: &mut Env, name: String, ty: Ty) {
    env.retain(|(n, _)| *n != name);
    env.push((name, ty));
}

struct Ctx {
    types: Vec<CustomType>,
    fns: Vec<FnSig>,
    counter: usize,
    /// Names that must NOT be shadowed or referenced from case-clause
    /// bodies in the current generation scope. Used to suppress the F-6
    /// shapes (see redteam/findings.md): Erlang codegen loses track of
    /// anonymous function parameters when they are (a) shadowed by `let`
    /// in one case clause body and used in later clauses, or (b) captured
    /// by a nested anonymous function. Once the compiler bug is fixed this
    /// protection can be removed and these shapes become excellent
    /// intended coverage.
    protected: Vec<String>,
}

impl Ctx {
    fn fresh(&mut self) -> String {
        let n = format!("v{}", self.counter);
        self.counter += 1;
        n
    }

    fn ty_name(&self, k: usize) -> &str {
        &self.types[k].name
    }

    /// Choose a name from the env to shadow, excluding protected names.
    fn pick_shadow_name(&self, u: &mut Unstructured<'_>, env: &Env) -> Result<Option<String>> {
        let candidates: Vec<&String> = env
            .iter()
            .map(|(n, _)| n)
            .filter(|n| !self.protected.contains(*n))
            .collect();
        if candidates.is_empty() {
            return Ok(None);
        }
        Ok(Some(pick(u, &candidates)?.to_string()))
    }
}

fn pick<'u, 's, T>(u: &mut Unstructured<'u>, xs: &'s [T]) -> Result<&'s T> {
    let i = u.int_in_range(0..=xs.len().saturating_sub(1))?;
    Ok(&xs[i])
}

fn chance(u: &mut Unstructured<'_>, pct: u8) -> Result<bool> {
    Ok(u.int_in_range(0..=99)? < pct)
}

fn roll(u: &mut Unstructured<'_>, weights: &[(u32, usize)]) -> Result<usize> {
    let total: u32 = weights.iter().map(|(w, _)| w).sum();
    let mut r = u.int_in_range(0..=total - 1)?;
    for (w, i) in weights {
        if r < *w {
            return Ok(*i);
        }
        r -= w;
    }
    Ok(weights.last().expect("nonempty weights").1)
}

// ---------------------------------------------------------------------------
// Module generation

/// Binding discipline for one subject position of a clause: `Free` means
/// patterns may bind arbitrary fresh names; `One(name, ty)` means the
/// pattern(s) must bind exactly `name` at a position of type `ty` (used to
/// satisfy the rule that alternative patterns bind identical names).
#[derive(Clone)]
enum BindSpec {
    Free,
    One(String, Ty),
}

impl<'a> Arbitrary<'a> for Module {
    fn arbitrary(u: &mut Unstructured<'a>) -> Result<Self> {
        let mut ctx = Ctx {
            types: Vec::new(),
            fns: Vec::new(),
            counter: 0,
            protected: Vec::new(),
        };

        // -- custom types ---------------------------------------------------
        let type_count = roll(u, &[(25, 0), (35, 1), (25, 2), (15, 3)])?;
        let mut used_type_names: Vec<String> = Vec::new();
        let mut used_ctor_names: Vec<String> = Vec::new();
        for _ in 0..type_count {
            let name = loop {
                let cand = if chance(u, 60)? {
                    ctx.fresh().to_uppercase()
                } else {
                    pick(u, TYPE_POOL)?.to_string()
                };
                if !used_type_names.contains(&cand) {
                    used_type_names.push(cand.clone());
                    break cand;
                }
            };
            let ctor_count = u.int_in_range(1..=3)?;
            let mut ctors = Vec::new();
            for _ in 0..ctor_count {
                let cname = loop {
                    let cand = if chance(u, 60)? {
                        format!("C{}", ctx.fresh())
                    } else {
                        pick(u, CTOR_POOL)?.to_string()
                    };
                    if !used_ctor_names.contains(&cand) {
                        used_ctor_names.push(cand.clone());
                        break cand;
                    }
                };
                let field_count = u.int_in_range(0..=2)?;
                let mut fields = Vec::new();
                let mut seen_labelled = false;
                let mut used_labels: Vec<String> = Vec::new();
                for _ in 0..field_count {
                    let fty = gen_simple_ty(u, &ctx.types)?;
                    // Unlabelled fields must precede labelled ones.
                    let label = if seen_labelled || chance(u, 40)? {
                        seen_labelled = true;
                        // Labels must be unique within a constructor.
                        let candidates: Vec<&str> = LABEL_POOL
                            .iter()
                            .filter(|l| !used_labels.contains(&l.to_string()))
                            .copied()
                            .collect();
                        match candidates.first() {
                            Some(l) => {
                                used_labels.push(l.to_string());
                                Some(l.to_string())
                            }
                            None => Some(format!("label{}", ctx.fresh())),
                        }
                    } else {
                        None
                    };
                    fields.push((label, fty));
                }
                ctors.push(Ctor {
                    name: cname,
                    fields,
                });
            }
            ctx.types.push(CustomType { name, ctors });
        }

        // -- recursion helper ------------------------------------------------
        let helper: Option<&'static str> = if chance(u, 50)? {
            let name = pick(u, &["spin", "walk"][..])?;
            let (params, ret) = if *name == "spin" {
                (
                    vec![("n".to_string(), Ty::Int), ("acc".to_string(), Ty::Int)],
                    Ty::Int,
                )
            } else {
                (
                    vec![
                        ("xs".to_string(), Ty::ListInt),
                        ("acc".to_string(), Ty::Int),
                    ],
                    Ty::Int,
                )
            };
            ctx.fns.push(FnSig {
                name: name.to_string(),
                params,
                ret,
            });
            Some(*name)
        } else {
            None
        };

        // -- functions --------------------------------------------------------
        let fn_count = u.int_in_range(1..=3)?;
        let mut functions: Vec<(FnSig, Expr)> = Vec::new();
        let mut used_fn_names: Vec<String> = ctx.fns.iter().map(|f| f.name.clone()).collect();
        for i in 0..fn_count {
            let mut name = if chance(u, 30)? {
                pick(u, FN_HOSTILE)?.to_string()
            } else {
                format!("f{i}")
            };
            if used_fn_names.contains(&name) {
                name = format!("f{i}");
            }
            used_fn_names.push(name.clone());
            let param_count = u.int_in_range(1..=3)?;
            let mut params: Vec<(String, Ty)> = Vec::new();
            for _ in 0..param_count {
                let mut pname = if chance(u, 50)? {
                    pick(u, VAR_POOL)?.to_string()
                } else {
                    ctx.fresh()
                };
                // Argument names must be unique within a function.
                if params.iter().any(|(n, _)| *n == pname) {
                    pname = ctx.fresh();
                }
                let pty = gen_any_ty(u, &ctx.types)?;
                params.push((pname, pty));
            }
            let ret = pick(u, &[Ty::Int, Ty::Str, Ty::Bool, Ty::ListInt])?.clone();
            let sig = FnSig {
                name: name.clone(),
                params: params.clone(),
                ret: ret.clone(),
            };
            let body = gen_expr(u, &mut ctx, &params, &ret, 3)?;
            ctx.fns.push(sig.clone());
            functions.push((sig, body));
        }

        // -- main -------------------------------------------------------------
        let mut main: Vec<Stmt> = Vec::new();
        let mut env: Env = Vec::new();
        let let_count = u.int_in_range(0..=2)?;
        for _ in 0..let_count {
            let ty = pick(u, &[Ty::Int, Ty::Str, Ty::Bool, Ty::ListInt])?.clone();
            let expr = gen_expr(u, &mut ctx, &env, &ty, 2)?;
            // Shadowing bias: sometimes reuse a name already bound in main.
            let name = if chance(u, 30)? {
                match ctx.pick_shadow_name(u, &env)? {
                    Some(n) => n,
                    None => pick(u, VAR_POOL)?.to_string(),
                }
            } else {
                pick(u, VAR_POOL)?.to_string()
            };
            env_push(&mut env, name.clone(), ty.clone());
            main.push(Stmt::Let(name, expr));
        }
        let echo_count = u.int_in_range(1..=4)?;
        for _ in 0..echo_count {
            let ty = pick(u, &[Ty::Int, Ty::Str, Ty::Bool, Ty::ListInt])?.clone();
            let expr = gen_expr(u, &mut ctx, &env, &ty, 3)?;
            main.push(Stmt::Echo(expr));
        }

        Ok(Module {
            types: ctx.types.clone(),
            helper,
            functions,
            main,
        })
    }
}

fn gen_simple_ty(u: &mut Unstructured<'_>, _types: &[CustomType]) -> Result<Ty> {
    Ok(pick(u, &[Ty::Int, Ty::Str, Ty::Bool, Ty::ListInt])?.clone())
}

fn gen_any_ty(u: &mut Unstructured<'_>, types: &[CustomType]) -> Result<Ty> {
    let mut weights: Vec<(u32, usize)> = vec![(30, 0), (20, 1), (25, 2), (15, 3), (10, 4)];
    if !types.is_empty() {
        weights.push((15, 5));
    }
    Ok(match roll(u, &weights)? {
        0 => Ty::Int,
        1 => Ty::Str,
        2 => Ty::Bool,
        3 => Ty::ListInt,
        4 => Ty::Tup(
            Box::new(gen_simple_ty(u, types)?),
            Box::new(gen_simple_ty(u, types)?),
        ),
        _ => Ty::Custom(u.int_in_range(0..=types.len() - 1)?),
    })
}

// ---------------------------------------------------------------------------
// Expression generation

fn gen_expr(u: &mut Unstructured<'_>, ctx: &mut Ctx, env: &Env, ty: &Ty, depth: u8) -> Result<Expr> {
    // Find variables in scope of the required type.
    let vars_of_ty: Vec<&String> = env
        .iter()
        .filter(|(_, t)| *t == *ty)
        .map(|(n, _)| n)
        .collect();
    if depth == 0 {
        if !vars_of_ty.is_empty() && chance(u, 50)? {
            return Ok(Expr::Var(pick(u, &vars_of_ty)?.to_string()));
        }
        return gen_base(u, ctx, env, ty);
    }

    let can_call = ctx.fns.iter().any(|f| f.ret == *ty);
    let can_pipe = can_call && matches!(ty, Ty::Int | Ty::Str | Ty::Bool | Ty::ListInt);
    let mut weights: Vec<(u32, usize)> = vec![(30, 0)]; // base
    if matches!(ty, Ty::Int | Ty::Str | Ty::Bool) {
        weights.push((20, 1)); // binop
    }
    if depth >= 2 {
        weights.push((25, 2)); // case
    }
    weights.push((8, 3)); // block
    if can_call {
        weights.push((10, 4));
    }
    if can_pipe {
        weights.push((5, 5));
    }
    weights.push((7, 6)); // anon fn application
    // F-10 suppression: immediately-applied anonymous functions crash
    // Erlang codegen whenever a parameter is referenced more than once
    // (`fn(v) { v + v }(10)`). Disabled entirely until fixed; the shape
    // becomes excellent intended coverage afterwards.
    if !ANON_APPLY_ENABLED || !ctx.protected.is_empty() {
        weights.retain(|(_, i)| *i != 6);
    }

    match roll(u, &weights)? {
        0 => {
            if !vars_of_ty.is_empty() && chance(u, 40)? {
                Ok(Expr::Var(pick(u, &vars_of_ty)?.to_string()))
            } else {
                gen_base(u, ctx, env, ty)
            }
        }
        1 => gen_binop(u, ctx, env, ty, depth),
        2 => gen_case_expr(u, ctx, env, ty, depth),
        3 => {
            let stmt_count = u.int_in_range(1..=2)?;
            let mut block_env = env.clone();
            let mut stmts: Vec<(String, Expr)> = Vec::new();
            for _ in 0..stmt_count {
                let lty = pick(u, &[Ty::Int, Ty::Str, Ty::Bool, Ty::ListInt])?.clone();
                let bound = gen_expr(u, ctx, &block_env, &lty, depth - 1)?;
                // Shadowing bias: reuse an in-scope name sometimes.
                let name = if chance(u, 25)? {
                    match ctx.pick_shadow_name(u, &block_env)? {
                        Some(n) => n,
                        None => pick(u, VAR_POOL)?.to_string(),
                    }
                } else {
                    pick(u, VAR_POOL)?.to_string()
                };
                env_push(&mut block_env, name.clone(), lty);
                stmts.push((name, bound));
            }
            let last = gen_expr(u, ctx, &block_env, ty, depth - 1)?;
            Ok(Expr::Block(stmts, Box::new(last)))
        }
        4 => gen_call(u, ctx, env, ty, depth),
        5 => {
            // pipe: <expr of param0 type> |> fname(<other args>)
            let sig: FnSig = {
                let candidates: Vec<&FnSig> = ctx
                    .fns
                    .iter()
                    .filter(|f| {
                        f.ret == *ty
                            && !f.params.is_empty()
                            && !env.iter().any(|(n, _)| *n == f.name)
                    })
                    .collect();
                if candidates.is_empty() {
                    return gen_call(u, ctx, env, ty, depth);
                }
                (*pick(u, &candidates)?).clone()
            };
            let first_ty = sig.params[0].1.clone();
            let first = gen_expr(u, ctx, env, &first_ty, depth - 1)?;
            let mut args = Vec::new();
            for (_, aty) in sig.params.iter().skip(1) {
                args.push(gen_expr(u, ctx, env, aty, 1)?);
            }
            Ok(Expr::Pipe {
                first: Box::new(first),
                name: sig.name.clone(),
                args,
            })
        }
        _ => {
            // anonymous function applied immediately
            let param_count = u.int_in_range(1..=2)?;
            let mut anon_env = env.clone();
            let mut params: Vec<String> = Vec::new();
            let mut args: Vec<Expr> = Vec::new();
            for _ in 0..param_count {
                let pty = pick(u, &[Ty::Int, Ty::Str, Ty::Bool])?.clone();
                let pname = ctx.fresh();
                env_push(&mut anon_env, pname.clone(), pty.clone());
                params.push(pname);
                args.push(gen_base(u, ctx, env, &pty)?);
            }
            // F-6 suppression: protect anon fn params from shadowing by
            // `let`s inside the body (see Ctx::protected).
            let saved_protected = ctx.protected.clone();
            ctx.protected.extend(params.iter().cloned());
            let body = gen_expr(u, ctx, &anon_env, ty, depth - 1);
            ctx.protected = saved_protected;
            let body = body?;
            Ok(Expr::ApplyAnon {
                params,
                body: Box::new(body),
                args,
            })
        }
    }
}

fn gen_base(u: &mut Unstructured<'_>, ctx: &mut Ctx, env: &Env, ty: &Ty) -> Result<Expr> {
    Ok(match ty {
        Ty::Int => Expr::IntLit(*pick(u, INT_POOL)?),
        Ty::Str => Expr::StrLit(*pick(u, STR_POOL)?),
        Ty::Bool => Expr::BoolLit(chance(u, 50)?),
        Ty::ListInt => {
            let n = u.int_in_range(0..=2)?;
            let mut elems = Vec::new();
            for _ in 0..n {
                elems.push(Expr::IntLit(*pick(u, INT_POOL)?));
            }
            Expr::ListLit(elems)
        }
        Ty::Tup(a, b) => Expr::TupLit(
            Box::new(gen_base(u, ctx, env, a)?),
            Box::new(gen_base(u, ctx, env, b)?),
        ),
        Ty::Custom(k) => {
            let ctor = pick(u, &ctx.types[*k].ctors)?.clone();
            let mut args = Vec::new();
            for (_, fty) in &ctor.fields {
                args.push(gen_base(u, ctx, env, fty)?);
            }
            Expr::Call {
                name: ctor.name.clone(),
                args,
            }
        }
    })
}

fn gen_binop(u: &mut Unstructured<'_>, ctx: &mut Ctx, env: &Env, ty: &Ty, depth: u8) -> Result<Expr> {
    Ok(match ty {
        Ty::Int => match roll(u, &[(30, 0), (30, 1), (20, 2), (15, 3), (5, 4)])? {
            0 => Expr::Bin(
                BinOp::Add,
                Box::new(gen_expr(u, ctx, env, &Ty::Int, depth - 1)?),
                Box::new(gen_expr(u, ctx, env, &Ty::Int, depth - 1)?),
            ),
            1 => Expr::Bin(
                BinOp::Sub,
                Box::new(gen_expr(u, ctx, env, &Ty::Int, depth - 1)?),
                Box::new(gen_expr(u, ctx, env, &Ty::Int, depth - 1)?),
            ),
            2 => Expr::Bin(
                BinOp::Mul,
                Box::new(gen_expr(u, ctx, env, &Ty::Int, depth - 1)?),
                Box::new(gen_expr(u, ctx, env, &Ty::Int, depth - 1)?),
            ),
            3 => Expr::Bin(
                BinOp::Rem,
                Box::new(gen_expr(u, ctx, env, &Ty::Int, depth - 1)?),
                Box::new(Expr::IntLit(u.int_in_range(1..=7)?)),
            ),
            _ => Expr::NegInt(Box::new(gen_expr(u, ctx, env, &Ty::Int, depth - 1)?)),
        },
        Ty::Str => Expr::Bin(
            BinOp::Concat,
            Box::new(gen_expr(u, ctx, env, &Ty::Str, depth - 1)?),
            Box::new(gen_expr(u, ctx, env, &Ty::Str, depth - 1)?),
        ),
        Ty::Bool => match roll(u, &[(35, 0), (25, 1), (25, 2), (15, 3)])? {
            0 => {
                // comparison of ints
                let op = *pick(
                    u,
                    &[BinOp::Eq, BinOp::Ne, BinOp::Lt, BinOp::Le, BinOp::Gt, BinOp::Ge],
                )?;
                Expr::Bin(
                    op,
                    Box::new(gen_expr(u, ctx, env, &Ty::Int, depth - 1)?),
                    Box::new(gen_expr(u, ctx, env, &Ty::Int, depth - 1)?),
                )
            }
            1 => {
                let op = *pick(u, &[BinOp::Eq, BinOp::Ne])?;
                Expr::Bin(
                    op,
                    Box::new(gen_expr(u, ctx, env, &Ty::Str, depth - 1)?),
                    Box::new(gen_expr(u, ctx, env, &Ty::Str, depth - 1)?),
                )
            }
            2 => {
                let op = *pick(u, &[BinOp::And, BinOp::Or])?;
                Expr::Bin(
                    op,
                    Box::new(gen_expr(u, ctx, env, &Ty::Bool, depth - 1)?),
                    Box::new(gen_expr(u, ctx, env, &Ty::Bool, depth - 1)?),
                )
            }
            _ => Expr::NegBool(Box::new(gen_expr(u, ctx, env, &Ty::Bool, depth - 1)?)),
        },
        _ => gen_base(u, ctx, env, ty)?,
    })
}

fn gen_call(u: &mut Unstructured<'_>, ctx: &mut Ctx, env: &Env, ty: &Ty, depth: u8) -> Result<Expr> {
    let candidates: Vec<FnSig> = ctx
        .fns
        .iter()
        .filter(|f| f.ret == *ty && !env.iter().any(|(n, _)| *n == f.name))
        .cloned()
        .collect();
    if candidates.is_empty() {
        return gen_base(u, ctx, env, ty);
    }
    let sig = pick(u, &candidates)?.clone();
    let mut args = Vec::new();
    for (_, aty) in &sig.params {
        args.push(gen_expr(u, ctx, env, aty, depth.saturating_sub(1))?.clone());
    }
    Ok(Expr::Call {
        name: sig.name,
        args,
    })
}

// ---------------------------------------------------------------------------
// Case generation (the hot zone: decision trees, prefixes, guards, aliases)

fn gen_case_expr(
    u: &mut Unstructured<'_>,
    ctx: &mut Ctx,
    env: &Env,
    ret: &Ty,
    depth: u8,
) -> Result<Expr> {
    let subj_count = if chance(u, 30)? { 2 } else { 1 };
    let mut subj_tys: Vec<Ty> = Vec::new();
    let mut subjs: Vec<Expr> = Vec::new();
    for _ in 0..subj_count {
        let sty = gen_case_subject_ty(u, &ctx.types)?;
        subjs.push(gen_expr(u, ctx, env, &sty, 1)?);
        subj_tys.push(sty);
    }

    let clause_count = u.int_in_range(2..=3)?;
    let mut clauses: Vec<Clause> = Vec::new();
    let mut used_int_lits: Vec<u32> = Vec::new();
    let mut used_str_lits: Vec<&'static str> = Vec::new();
    let mut used_ctors: Vec<String> = Vec::new();

    for i in 0..clause_count {
        let is_last = i == clause_count - 1;
        // Alternative patterns only for single-subject cases.
        // Alternative patterns only for single-subject cases.
        // F-7/F-8/F-9 suppression: NO alternatives on list subjects — the
        // Erlang decision-tree compiler loses variable registrations for
        // alternative list patterns following other list clauses.
        let alts_allowed = subj_count == 1 && !matches!(subj_tys[0], Ty::ListInt);
        let wants_alts = alts_allowed && chance(u, 25)?;
        let bind_spec = if alts_allowed && chance(u, 30)? {
            let name = pick(u, &["a", "b", "inner", "item", "constructor"][..])?.to_string();
            let bty = pick(u, &[Ty::Int, Ty::Str, Ty::Bool])?.clone();
            BindSpec::One(name, bty)
        } else {
            BindSpec::Free
        };

        let mut pats: Vec<Pattern> = Vec::new();
        let mut bound: Vec<(String, Ty)> = Vec::new();
        for sty in &subj_tys {
            let pat = gen_pattern(
                u,
                ctx,
                env,
                &mut bound,
                &bind_spec,
                sty,
                1,
                &mut used_int_lits,
                &mut used_str_lits,
                &mut used_ctors,
                is_last,
                !wants_alts,
            )?;
            pats.push(pat);
        }

        // Alternatives for single-subject cases. Alternative patterns must
        // bind exactly the same variables as the initial pattern, so the
        // binding set of the first subject's pattern drives what we may
        // generate.
        let mut alts: Vec<Pattern> = Vec::new();
        if wants_alts {
            let subj0_binds = &bound[..];
            let alt = match (&subj_tys[0], subj0_binds) {
                (_, []) => Some(gen_alt_pattern(
                    u,
                    ctx,
                    &BindSpec::Free,
                    &subj_tys[0],
                    &mut used_int_lits,
                    &mut used_str_lits,
                )?),
                (Ty::ListInt | Ty::Str, [(n, t)]) => Some(gen_alt_pattern(
                    u,
                    ctx,
                    &BindSpec::One(n.clone(), t.clone()),
                    &subj_tys[0],
                    &mut used_int_lits,
                    &mut used_str_lits,
                )?),
                _ => None,
            };
            if let Some(alt) = alt {
                alts.push(alt);
            }
        }

        let all_catchall = pats
            .iter()
            .all(|p| matches!(p, Pattern::Discard | Pattern::Var(_)));
        let guardable = bound
            .iter()
            .any(|(_, t)| matches!(t, Ty::Int | Ty::Str | Ty::Bool));
        // F-7 suppression: guards on alternative list patterns crash
        // Erlang codegen when following an exact-length list clause.
        // F-7/F-11 suppression: no guards on clauses with alternatives —
        // the Erlang decision-tree compiler loses guard-variable scope
        // registrations for those (list AND string subjects).
        let guard = if !is_last && !all_catchall && guardable && alts.is_empty() && chance(u, 40)? {
            Some(gen_guard(u, ctx, &bound)?)
        } else {
            None
        };

        let mut body_env = env.clone();
        // F-6 suppression: anonymous fn params may not be referenced from
        // case clause bodies.
        body_env.retain(|(n, _)| !ctx.protected.contains(n));
        for (n, t) in &bound {
            env_push(&mut body_env, n.clone(), t.clone());
        }
        let body = gen_expr(u, ctx, &body_env, ret, depth - 1)?;
        clauses.push(Clause {
            pats,
            alts,
            guard,
            body,
        });
    }

    // Exhaustiveness: if no clause is an unguarded catch-all (and the
    // patterns don't obviously cover the type), append one.
    if !covers(ctx, &subj_tys, &clauses) {
        let pats: Vec<Pattern> = subj_tys
            .iter()
            .map(|_| {
                if chance(u, 50).unwrap_or(false) {
                    Pattern::Discard
                } else {
                    Pattern::Var(ctx.fresh())
                }
            })
            .collect();
        let mut body_env = env.clone();
        body_env.retain(|(n, _)| !ctx.protected.contains(n));
        for (i, p) in pats.iter().enumerate() {
            if let Pattern::Var(name) = p {
                env_push(&mut body_env, name.clone(), subj_tys[i].clone());
            }
        }
        let body = gen_expr(u, ctx, &body_env, ret, depth - 1)?;
        clauses.push(Clause {
            pats,
            alts: Vec::new(),
            guard: None,
            body,
        });
    }

    Ok(Expr::Case { subjs, clauses })
}

fn covers(ctx: &Ctx, subj_tys: &[Ty], clauses: &[Clause]) -> bool {
    for c in clauses {
        let catchall = c.pats.iter().all(|p| match p {
            Pattern::Discard | Pattern::Var(_) => true,
            Pattern::Alias(inner, _) => matches!(**inner, Pattern::Discard | Pattern::Var(_)),
            _ => false,
        });
        if catchall && c.guard.is_none() {
            return true;
        }
    }
    if let [Ty::Bool] = subj_tys {
        let mut seen = (false, false);
        for c in clauses {
            if c.guard.is_some() {
                continue;
            }
            for p in &c.pats {
                match p {
                    Pattern::BoolLit(true) => seen.0 = true,
                    Pattern::BoolLit(false) => seen.1 = true,
                    _ => {}
                }
            }
        }
        if seen.0 && seen.1 {
            return true;
        }
    }
    if let [Ty::Custom(k)] = subj_tys {
        let all: Vec<&str> = ctx.types[*k].ctors.iter().map(|c| c.name.as_str()).collect();
        let used: Vec<&str> = clauses
            .iter()
            .filter(|c| c.guard.is_none())
            .filter_map(|c| match &c.pats[0] {
                Pattern::CtorPat { name, fields }
                    if fields
                        .iter()
                        .all(|f| matches!(f, Pattern::Discard | Pattern::Var(_))) =>
                {
                    Some(name.as_str())
                }
                _ => None,
            })
            .collect();
        if all.iter().all(|n| used.contains(n)) {
            return true;
        }
    }
    false
}

fn gen_case_subject_ty(u: &mut Unstructured<'_>, types: &[CustomType]) -> Result<Ty> {
    let mut weights: Vec<(u32, usize)> = vec![(25, 0), (30, 1), (15, 2), (15, 3), (5, 4)];
    if !types.is_empty() {
        weights.push((20, 5));
    }
    Ok(match roll(u, &weights)? {
        0 => Ty::Int,
        1 => Ty::Str,
        2 => Ty::Bool,
        3 => Ty::ListInt,
        4 => Ty::Tup(
            Box::new(gen_simple_ty(u, types)?),
            Box::new(gen_simple_ty(u, types)?),
        ),
        _ => Ty::Custom(u.int_in_range(0..=types.len() - 1)?),
    })
}

#[allow(clippy::too_many_arguments)]
fn gen_pattern(
    u: &mut Unstructured<'_>,
    ctx: &mut Ctx,
    env: &Env,
    bound: &mut Vec<(String, Ty)>,
    spec: &BindSpec,
    ty: &Ty,
    depth: u8,
    used_ints: &mut Vec<u32>,
    used_strs: &mut Vec<&'static str>,
    used_ctors: &mut Vec<String>,
    is_last: bool,
    allow_alias: bool,
) -> Result<Pattern> {
    // BindSpec::One requires a binding position of exactly that type.
    if let BindSpec::One(name, bty) = spec {
        return gen_one_pattern(u, ctx, bound, name, bty, ty, is_last);
    }

    let binder = |u: &mut Unstructured<'_>,
                  bound: &mut Vec<(String, Ty)>,
                  ctx: &mut Ctx,
                  ty: &Ty|
     -> Result<Pattern> {
        // Shadowing bias: sometimes reuse a name from the outer env.
        let name = if chance(u, 20)? {
            match ctx.pick_shadow_name(u, env)? {
                Some(n) => n,
                None => pick(u, VAR_POOL)?.to_string(),
            }
        } else if chance(u, 40)? {
            pick(u, VAR_POOL)?.to_string()
        } else {
            ctx.fresh()
        };
        // Never bind the same name twice in one clause.
        if bound.iter().any(|(n, _)| *n == name) {
            return Ok(Pattern::Discard);
        }
        bound.push((name.clone(), ty.clone()));
        Ok(Pattern::Var(name))
    };

    let mut pat = match ty {
        Ty::Int => match roll(u, &[(50, 0), (20, 1), (30, 2)])? {
            0 => {
                let lit = fresh_int_lit(u, used_ints)?;
                used_ints.push(lit);
                Pattern::IntLit(lit)
            }
            1 => binder(u, bound, ctx, ty)?,
            _ => Pattern::Discard,
        },
        Ty::Str => match roll(u, &[(35, 0), (25, 1), (15, 2), (25, 3)])? {
            0 => {
                let lit = fresh_str_lit(u, used_strs)?;
                used_strs.push(lit);
                Pattern::StrLit(lit)
            }
            1 => {
                let prefix = *pick(u, STR_POOL)?;
                let rest = if chance(u, 60)? {
                    let candidates: Vec<&str> = ["rest", "tail", "suffix", "s"]
                        .into_iter()
                        .filter(|n| !bound.iter().any(|(b, _)| b == n))
                        .collect();
                    match candidates.first() {
                        Some(name) => {
                            bound.push((name.to_string(), Ty::Str));
                            Some(name.to_string())
                        }
                        None => None,
                    }
                } else {
                    None
                };
                Pattern::Prefix(prefix, rest)
            }
            2 => binder(u, bound, ctx, ty)?,
            _ => Pattern::Discard,
        },
        Ty::Bool => match roll(u, &[(50, 0), (20, 1), (30, 2)])? {
            0 => Pattern::BoolLit(chance(u, 50)?),
            1 => binder(u, bound, ctx, ty)?,
            _ => Pattern::Discard,
        },
        Ty::ListInt => gen_list_pattern(u, ctx, env, bound, ty)?,
        Ty::Tup(a, b) => Pattern::TupPat(
            Box::new(gen_pattern(
                u, ctx, env, bound, &BindSpec::Free, a, depth - 1, used_ints, used_strs,
                used_ctors, is_last, true,
            )?),
            Box::new(gen_pattern(
                u, ctx, env, bound, &BindSpec::Free, b, depth - 1, used_ints, used_strs,
                used_ctors, is_last, true,
            )?),
        ),
        Ty::Custom(k) => {
            match roll(u, &[(60, 0), (15, 1), (25, 2)])? {
                0 => {
                    let ctor = pick(u, &ctx.types[*k].ctors)?.clone();
                    let mut fields = Vec::new();
                    for (_, fty) in &ctor.fields {
                        fields.push(gen_pattern(
                            u,
                            ctx,
                            env,
                            bound,
                            &BindSpec::Free,
                            fty,
                            depth - 1,
                            used_ints,
                            used_strs,
                            used_ctors,
                            is_last,
                            true,
                        )?);
                    }
                    used_ctors.push(ctor.name.clone());
                    Pattern::CtorPat {
                        name: ctor.name.clone(),
                        fields,
                    }
                }
                1 => binder(u, bound, ctx, ty)?,
                _ => Pattern::Discard,
            }
        }
    };

    // Alias patterns (whole-pattern binding) — only when the pattern isn't
    // already a bare variable and only when not last-position generated
    // alternatives are in play (alternatives handled by caller).
    if allow_alias && !matches!(pat, Pattern::Var(_) | Pattern::Discard) && chance(u, 12)? {
        let candidates: Vec<&str> = ["whole", "it", "subject_"]
            .into_iter()
            .filter(|n| !bound.iter().any(|(b, _)| b == n))
            .collect();
        if let Some(name) = candidates.first() {
            bound.push((name.to_string(), ty.clone()));
            pat = Pattern::Alias(Box::new(pat), name.to_string());
        }
    }
    Ok(pat)
}

fn gen_one_pattern(
    u: &mut Unstructured<'_>,
    ctx: &mut Ctx,
    bound: &mut Vec<(String, Ty)>,
    name: &str,
    bty: &Ty,
    ty: &Ty,
    _is_last: bool,
) -> Result<Pattern> {
    // Patterns that bind exactly `name` at a position of type `bty`.
    let pat = match (ty, bty) {
        (Ty::Str, Ty::Str) => {
            let prefix = pick(u, STR_POOL)?;
            bound.push((name.to_string(), Ty::Str));
            Pattern::Prefix(prefix, Some(name.to_string()))
        }
        (Ty::ListInt, Ty::Int) => {
            bound.push((name.to_string(), Ty::Int));
            if chance(u, 50)? {
                Pattern::ListCons {
                    elems: vec![Pattern::Var(name.to_string())],
                    rest: RestPat::Closed,
                }
            } else {
                Pattern::ListCons {
                    elems: vec![Pattern::Var(name.to_string()), Pattern::Discard],
                    rest: RestPat::Closed,
                }
            }
        }
        (Ty::Custom(k), _) => {
            let ctors = &ctx.types[*k].ctors;
            // Find a ctor with a field of the bound type; else bind whole.
            let compatible: Vec<&Ctor> = ctors
                .iter()
                .filter(|c| c.fields.iter().any(|(_, f)| f == bty))
                .collect();
            if compatible.is_empty() {
                bound.push((name.to_string(), ty.clone()));
                Pattern::Var(name.to_string())
            } else {
                let ctor = pick(u, &compatible)?;
                let fields: Vec<Pattern> = ctor
                    .fields
                    .iter()
                    .map(|(_, f)| {
                        if f == bty && !bound.iter().any(|(n, _)| n.as_str() == name) {
                            bound.push((name.to_string(), f.clone()));
                            Pattern::Var(name.to_string())
                        } else {
                            Pattern::Discard
                        }
                    })
                    .collect();
                Pattern::CtorPat {
                    name: ctor.name.clone(),
                    fields,
                }
            }
        }
        _ => {
            bound.push((name.to_string(), ty.clone()));
            Pattern::Var(name.to_string())
        }
    };
    Ok(pat)
}

fn gen_alt_pattern(
    u: &mut Unstructured<'_>,
    ctx: &mut Ctx,
    spec: &BindSpec,
    ty: &Ty,
    used_ints: &mut Vec<u32>,
    used_strs: &mut Vec<&'static str>,
) -> Result<Pattern> {
    // Alternative patterns must bind the same names as the main pattern.
    // If a One binding is active, reproduce exactly it; otherwise only
    // binding-free patterns are allowed here.
    if let BindSpec::One(name, bty) = spec {
        return match (ty, bty) {
            (Ty::ListInt, Ty::Int) => Ok(Pattern::ListCons {
                elems: vec![Pattern::Var(name.clone())],
                rest: RestPat::Open,
            }),
            (Ty::Str, Ty::Str) => Ok(Pattern::Prefix(*pick(u, STR_POOL)?, Some(name.clone()))),
            _ => Ok(Pattern::Var(name.clone())),
        };
    }
    Ok(match ty {
        Ty::Int => {
            let lit = fresh_int_lit(u, used_ints)?;
            used_ints.push(lit);
            Pattern::IntLit(lit)
        }
        Ty::Str => {
            if chance(u, 50)? {
                let lit = fresh_str_lit(u, used_strs)?;
                used_strs.push(lit);
                Pattern::StrLit(lit)
            } else {
                Pattern::Prefix(*pick(u, STR_POOL)?, None)
            }
        }
        Ty::Bool => Pattern::BoolLit(chance(u, 50)?),
        Ty::ListInt => match roll(u, &[(40, 0), (30, 1), (30, 2)])? {
            0 => Pattern::ListNil,
            1 => Pattern::ListCons {
                elems: vec![Pattern::Discard],
                rest: RestPat::Closed,
            },
            _ => Pattern::ListCons {
                elems: vec![Pattern::Discard, Pattern::Discard],
                rest: RestPat::Open,
            },
        },
        Ty::Tup(a, b) => Pattern::TupPat(
            Box::new(gen_alt_pattern(u, ctx, spec, a, used_ints, used_strs)?),
            Box::new(gen_alt_pattern(u, ctx, spec, b, used_ints, used_strs)?),
        ),
        Ty::Custom(k) => {
            let ctor = pick(u, &ctx.types[*k].ctors)?;
            Pattern::CtorPat {
                name: ctor.name.clone(),
                fields: ctor.fields.iter().map(|_| Pattern::Discard).collect(),
            }
        }
    })
}

fn gen_list_pattern(
    u: &mut Unstructured<'_>,
    ctx: &mut Ctx,
    env: &Env,
    bound: &mut Vec<(String, Ty)>,
    _ty: &Ty,
) -> Result<Pattern> {
    let elem = |u: &mut Unstructured<'_>, bound: &mut Vec<(String, Ty)>, ctx: &mut Ctx| {
        match roll(u, &[(40, 0), (35, 1), (25, 2)]) {
            Ok(0) => Ok(Pattern::IntLit(u.int_in_range(0..=9)?)),
            Ok(1) => {
                let name = if chance(u, 20).unwrap_or(false) {
                    match ctx.pick_shadow_name(u, env).unwrap_or(None) {
                        Some(n) => n,
                        None => pick(u, &["a", "b", "h", "x", "constructor"][..])
                            .unwrap_or(&"a")
                            .to_string(),
                    }
                } else {
                    pick(u, &["a", "b", "h", "x", "constructor"][..])?.to_string()
                };
                if bound.iter().any(|(n, _)| *n == name) {
                    Ok(Pattern::Discard)
                } else {
                    bound.push((name.clone(), Ty::Int));
                    Ok(Pattern::Var(name))
                }
            }
            _ => Ok(Pattern::Discard),
        }
    };
    Ok(match roll(u, &[(20, 0), (25, 1), (25, 2), (30, 3)])? {
        0 => Pattern::ListNil,
        1 => Pattern::ListCons {
            elems: vec![elem(u, bound, ctx)?],
            rest: RestPat::Closed,
        },
        2 => Pattern::ListCons {
            elems: vec![elem(u, bound, ctx)?, elem(u, bound, ctx)?],
            rest: RestPat::Open,
        },
        _ => {
            let candidates: Vec<&str> = ["rest", "tail", "tl"]
                .into_iter()
                .filter(|n| !bound.iter().any(|(b, _)| b == n))
                .collect();
            match candidates.first() {
                Some(rest_name) => {
                    bound.push((rest_name.to_string(), Ty::ListInt));
                    Pattern::ListCons {
                        elems: vec![elem(u, bound, ctx)?],
                        rest: RestPat::Named(rest_name.to_string()),
                    }
                }
                None => Pattern::ListCons {
                    elems: vec![elem(u, bound, ctx)?],
                    rest: RestPat::Open,
                },
            }
        }
    })
}

fn fresh_int_lit(u: &mut Unstructured<'_>, used: &[u32]) -> Result<u32> {
    let mut candidates: Vec<u32> = (0..=9).filter(|n| !used.contains(n)).collect();
    if candidates.is_empty() {
        candidates.push(10);
    }
    Ok(candidates[u.int_in_range(0..=candidates.len() - 1)?])
}

fn fresh_str_lit(u: &mut Unstructured<'_>, used: &[&'static str]) -> Result<&'static str> {
    let candidates: Vec<&'static str> = STR_POOL
        .iter()
        .filter(|s| !used.contains(*s) && !s.is_empty())
        .copied()
        .collect();
    if candidates.is_empty() {
        return Ok("zzz");
    }
    Ok(candidates[u.int_in_range(0..=candidates.len() - 1)?])
}

fn gen_guard(u: &mut Unstructured<'_>, ctx: &mut Ctx, bound: &[(String, Ty)]) -> Result<Expr> {
    let usable: Vec<&(String, Ty)> = bound
        .iter()
        .filter(|(_, t)| matches!(t, Ty::Int | Ty::Str | Ty::Bool))
        .collect();
    let atom = |u: &mut Unstructured<'_>, _ctx: &mut Ctx| -> Result<Expr> {
        let (name, ty) = pick(u, &usable)?;
        Ok(match ty {
            Ty::Int => {
                let lit = u.int_in_range(0..=9)?;
                match roll(u, &[(30, 0), (30, 1), (25, 2), (15, 3)])? {
                    0 => Expr::Bin(BinOp::Gt, Box::new(Expr::Var(name.clone())), Box::new(Expr::IntLit(lit))),
                    1 => Expr::Bin(BinOp::Le, Box::new(Expr::Var(name.clone())), Box::new(Expr::IntLit(lit))),
                    2 => Expr::Bin(BinOp::Eq, Box::new(Expr::Var(name.clone())), Box::new(Expr::IntLit(lit))),
                    _ => Expr::Bin(
                        BinOp::Eq,
                        Box::new(Expr::Bin(
                            BinOp::Rem,
                            Box::new(Expr::Var(name.clone())),
                            Box::new(Expr::IntLit(2)),
                        )),
                        Box::new(Expr::IntLit(0)),
                    ),
                }
            }
            Ty::Str => {
                let lit = *pick(u, STR_POOL)?;
                let op = *pick(u, &[BinOp::Eq, BinOp::Ne])?;
                Expr::Bin(op, Box::new(Expr::Var(name.clone())), Box::new(Expr::StrLit(lit)))
            }
            _ => {
                if chance(u, 50)? {
                    Expr::Var(name.clone())
                } else {
                    Expr::NegBool(Box::new(Expr::Var(name.clone())))
                }
            }
        })
    };
    let left = atom(u, ctx)?;
    if chance(u, 35)? {
        let right = atom(u, ctx)?;
        let op = *pick(u, &[BinOp::And, BinOp::Or])?;
        Ok(Expr::Bin(op, Box::new(left), Box::new(right)))
    } else {
        Ok(left)
    }
}

// ---------------------------------------------------------------------------
// Rendering

impl Module {
    pub fn to_source(&self) -> String {
        let mut out = String::new();
        for t in &self.types {
            out.push_str("pub type ");
            out.push_str(&t.name);
            out.push_str(" {\n");
            for c in &t.ctors {
                out.push_str("  ");
                out.push_str(&c.name);
                if !c.fields.is_empty() {
                    out.push('(');
                    let fields: Vec<String> = c
                        .fields
                        .iter()
                        .map(|(label, fty)| match label {
                            Some(l) => format!("{l}: {}", ty_str(fty, &self.types)),
                            None => ty_str(fty, &self.types),
                        })
                        .collect();
                    out.push_str(&fields.join(", "));
                    out.push(')');
                }
                out.push('\n');
            }
            out.push_str("}\n\n");
        }

        if let Some(helper) = self.helper {
            match helper {
                "spin" => out.push_str(
                    "fn spin(n: Int, acc: Int) -> Int {\n  case n <= 0 {\n    True -> acc\n    False -> spin(n - 1, acc + n)\n  }\n}\n\n",
                ),
                _ => out.push_str(
                    "fn walk(xs: List(Int), acc: Int) -> Int {\n  case xs {\n    [] -> acc\n    [x, ..rest] -> walk(rest, acc + x)\n  }\n}\n\n",
                ),
            }
        }

        for (sig, body) in &self.functions {
            out.push_str("fn ");
            out.push_str(&sig.name);
            out.push('(');
            let params: Vec<String> = sig
                .params
                .iter()
                .map(|(n, t)| format!("{n}: {}", ty_str(t, &self.types)))
                .collect();
            out.push_str(&params.join(", "));
            out.push_str(") -> ");
            out.push_str(&ty_str(&sig.ret, &self.types));
            out.push_str(" {\n");
            write_expr(&mut out, body, &self.types, 1);
            out.push_str("\n}\n\n");
        }

        out.push_str("pub fn main() {\n");
        for stmt in &self.main {
            out.push_str("  ");
            match stmt {
                Stmt::Let(name, expr) => {
                    out.push_str("let ");
                    out.push_str(name);
                    out.push_str(" = ");
                    write_expr(&mut out, expr, &self.types, 1);
                }
                Stmt::Echo(expr) => {
                    out.push_str("echo ");
                    write_expr(&mut out, expr, &self.types, 1);
                }
            }
            out.push('\n');
        }
        out.push_str("}\n");
        out
    }

    /// Deterministic generation from a 64-bit seed (xorshift-expanded into
    /// the byte stream consumed by `Arbitrary`).
    pub fn from_seed(seed: u64) -> Module {
        let mut state = seed ^ 0x9E37_79B9_7F4A_7C15;
        let mut bytes = vec![0u8; 2048];
        for _ in 0..8 {
            for chunk in bytes.chunks_mut(8) {
                state ^= state << 13;
                state ^= state >> 7;
                state ^= state << 17;
                let le = state.to_le_bytes();
                let n = chunk.len();
                chunk.copy_from_slice(&le[..n]);
            }
            let mut u = Unstructured::new(&bytes);
            if let Ok(m) = Module::arbitrary(&mut u) {
                return m;
            }
        }
        // Unreachable in practice; a valid fallback module.
        Module {
            types: Vec::new(),
            helper: None,
            functions: vec![(
                FnSig {
                    name: "f0".to_string(),
                    params: vec![("x".to_string(), Ty::Int)],
                    ret: Ty::Int,
                },
                Expr::Var("x".to_string()),
            )],
            main: vec![Stmt::Echo(Expr::IntLit(0))],
        }
    }
}

fn ty_str(ty: &Ty, types: &[CustomType]) -> String {
    match ty {
        Ty::Int => "Int".to_string(),
        Ty::Str => "String".to_string(),
        Ty::Bool => "Bool".to_string(),
        Ty::ListInt => "List(Int)".to_string(),
        Ty::Tup(a, b) => format!("#({}, {})", ty_str(a, types), ty_str(b, types)),
        Ty::Custom(k) => types[*k].name.clone(),
    }
}

fn binop_str(op: BinOp) -> &'static str {
    match op {
        BinOp::Add => "+",
        BinOp::Sub => "-",
        BinOp::Mul => "*",
        BinOp::Rem => "%",
        BinOp::Eq => "==",
        BinOp::Ne => "!=",
        BinOp::Lt => "<",
        BinOp::Le => "<=",
        BinOp::Gt => ">",
        BinOp::Ge => ">=",
        BinOp::And => "&&",
        BinOp::Or => "||",
        BinOp::Concat => "<>",
    }
}

/// Gleam has no `(expr)` grouping syntax — `{ }` blocks are the grouping
/// construct. Operand positions therefore wrap non-atomic expressions in
/// block braces. (This is precedence-blunt but always valid, and earns us
/// extra block codegen coverage.)
fn atomic(e: &Expr) -> bool {
    matches!(
        e,
        Expr::IntLit(_)
            | Expr::StrLit(_)
            | Expr::BoolLit(_)
            | Expr::Var(_)
            | Expr::ListLit(_)
            | Expr::TupLit(..)
            | Expr::Call { .. }
    )
}

fn write_operand(out: &mut String, e: &Expr, types: &[CustomType], ind: usize) {
    if atomic(e) {
        return write_expr(out, e, types, ind);
    }
    out.push('{');
    push_indent(out, ind + 1);
    write_expr(out, e, types, ind + 1);
    push_indent(out, ind);
    out.push('}');
}

fn write_expr(out: &mut String, e: &Expr, types: &[CustomType], ind: usize) {
    match e {
        Expr::IntLit(n) => out.push_str(&n.to_string()),
        Expr::StrLit(s) => {
            out.push('"');
            out.push_str(s);
            out.push('"');
        }
        Expr::BoolLit(b) => out.push_str(if *b { "True" } else { "False" }),
        Expr::Var(name) => out.push_str(name),
        Expr::ListLit(elems) => {
            out.push('[');
            for (i, el) in elems.iter().enumerate() {
                if i > 0 {
                    out.push_str(", ");
                }
                write_expr(out, el, types, ind);
            }
            out.push(']');
        }
        Expr::TupLit(a, b) => {
            out.push_str("#(");
            write_expr(out, a, types, ind);
            out.push_str(", ");
            write_expr(out, b, types, ind);
            out.push(')');
        }
        Expr::Bin(op, l, r) => {
            write_operand(out, l, types, ind);
            out.push(' ');
            out.push_str(binop_str(*op));
            out.push(' ');
            write_operand(out, r, types, ind);
        }
        Expr::NegBool(x) => {
            out.push('!');
            write_operand(out, x, types, ind);
        }
        Expr::NegInt(x) => {
            // `-{` at the start of a statement parses as binary subtraction
            // glued to the previous statement, so emit `0 - <operand>`.
            out.push_str("0 - ");
            write_operand(out, x, types, ind);
        }
        Expr::Case { subjs, clauses } => {
            out.push_str("case ");
            for (i, s) in subjs.iter().enumerate() {
                if i > 0 {
                    out.push_str(", ");
                }
                write_expr(out, s, types, ind + 1);
            }
            out.push_str(" {");
            for c in clauses {
                push_indent(out, ind + 1);
                write_clause(out, c, types, ind + 1);
            }
            push_indent(out, ind);
            out.push('}');
        }
        Expr::Block(stmts, last) => {
            out.push('{');
            for (name, bound) in stmts {
                push_indent(out, ind + 1);
                out.push_str("let ");
                out.push_str(name);
                out.push_str(" = ");
                write_expr(out, bound, types, ind + 1);
            }
            push_indent(out, ind + 1);
            write_expr(out, last, types, ind + 1);
            push_indent(out, ind);
            out.push('}');
        }
        Expr::Call { name, args } => {
            out.push_str(name);
            if !args.is_empty() {
                out.push('(');
                for (i, a) in args.iter().enumerate() {
                    if i > 0 {
                        out.push_str(", ");
                    }
                    write_expr(out, a, types, ind);
                }
                out.push(')');
            }
        }
        Expr::Pipe { first, name, args } => {
            write_operand(out, first, types, ind);
            out.push_str(" |> ");
            out.push_str(name);
            out.push('(');
            for (i, a) in args.iter().enumerate() {
                if i > 0 {
                    out.push_str(", ");
                }
                write_expr(out, a, types, ind);
            }
            out.push(')');
        }
        Expr::ApplyAnon { params, body, args } => {
            out.push_str("fn(");
            out.push_str(&params.join(", "));
            out.push_str(") { ");
            write_expr(out, body, types, ind);
            out.push_str(" }(");
            for (i, a) in args.iter().enumerate() {
                if i > 0 {
                    out.push_str(", ");
                }
                write_expr(out, a, types, ind);
            }
            out.push(')');
        }
    }
}

fn write_clause(out: &mut String, c: &Clause, types: &[CustomType], ind: usize) {
    let last = c.pats.len() - 1;
    for (i, p) in c.pats.iter().enumerate() {
        write_pattern(out, p, types);
        if i != last {
            out.push_str(", ");
        }
    }
    for alt in &c.alts {
        out.push_str(" | ");
        write_pattern(out, alt, types);
    }
    if let Some(g) = &c.guard {
        out.push_str(" if ");
        write_guard(out, g, types, ind);
    }
    out.push_str(" -> ");
    write_expr(out, &c.body, types, ind);
}

fn write_pattern(out: &mut String, p: &Pattern, types: &[CustomType]) {
    match p {
        Pattern::Discard => out.push('_'),
        Pattern::Var(name) => out.push_str(name),
        Pattern::Alias(pat, name) => {
            write_pattern(out, pat, types);
            out.push_str(" as ");
            out.push_str(name);
        }
        Pattern::IntLit(n) => out.push_str(&n.to_string()),
        Pattern::StrLit(s) => {
            out.push('"');
            out.push_str(s);
            out.push('"');
        }
        Pattern::BoolLit(b) => out.push_str(if *b { "True" } else { "False" }),
        Pattern::Prefix(prefix, rest) => {
            out.push('"');
            out.push_str(prefix);
            out.push_str("\" <> ");
            match rest {
                Some(name) => out.push_str(name),
                None => out.push('_'),
            }
        }
        Pattern::ListNil => out.push_str("[]"),
        Pattern::ListCons { elems, rest } => {
            out.push('[');
            for (i, el) in elems.iter().enumerate() {
                if i > 0 {
                    out.push_str(", ");
                }
                write_pattern(out, el, types);
            }
            match rest {
                RestPat::Closed => {}
                RestPat::Open => out.push_str(", .."),
                RestPat::Named(name) => {
                    out.push_str(", ..");
                    out.push_str(name);
                }
            }
            out.push(']');
        }
        Pattern::CtorPat { name, fields } => {
            out.push_str(name);
            if !fields.is_empty() {
                out.push('(');
                for (i, f) in fields.iter().enumerate() {
                    if i > 0 {
                        out.push_str(", ");
                    }
                    write_pattern(out, f, types);
                }
                out.push(')');
            }
        }
        Pattern::TupPat(a, b) => {
            out.push_str("#(");
            write_pattern(out, a, types);
            out.push_str(", ");
            write_pattern(out, b, types);
            out.push(')');
        }
    }
}

/// Guards live in a restricted grammar: no parenthesised expressions, no
/// blocks. The guard generator only produces shapes that are
/// precedence-safe rendered flat (comparisons/remainder atoms combined
/// with && / || at the top level), so we write them without any grouping.
fn write_guard(out: &mut String, e: &Expr, types: &[CustomType], ind: usize) {
    match e {
        Expr::Bin(op, l, r) => {
            write_guard(out, l, types, ind);
            out.push(' ');
            out.push_str(binop_str(*op));
            out.push(' ');
            write_guard(out, r, types, ind);
        }
        Expr::NegBool(x) => {
            out.push('!');
            write_guard(out, x, types, ind);
        }
        _ => write_expr(out, e, types, ind),
    }
}

fn push_indent(out: &mut String, ind: usize) {
    out.push('\n');
    for _ in 0..ind {
        out.push_str("  ");
    }
}

// ---------------------------------------------------------------------------
// Validation: the generator's own contract, checked against the real
// compiler. Run with `cargo test -p gleam-smith`.

#[cfg(test)]
mod tests {
    use super::*;
    use gleam_core::redteam::ProbeOutcome;

    #[test]
    fn determinism() {
        for seed in [0u64, 1, 2, 42, 123_456_789] {
            assert_eq!(
                Module::from_seed(seed).to_source(),
                Module::from_seed(seed).to_source()
            );
        }
    }

    /// Replay a fuzz artifact (raw Arbitrary entropy) manually:
    ///   REDTEAM_ARTIFACT=path cargo test -p gleam-smith replay_artifact -- --ignored --nocapture
    #[test]
    #[ignore = "manual artifact replay helper"]
    fn replay_artifact() {
        let path = std::env::var("REDTEAM_ARTIFACT").expect("set REDTEAM_ARTIFACT");
        let data = std::fs::read(&path).expect("read artifact");
        let mut u = Unstructured::new(&data);
        let module = Module::arbitrary(&mut u).expect("artifact decodes");
        let src = module.to_source();
        println!("--- generated source:\n{src}");
        match gleam_core::redteam::probe_guarded(src.as_bytes()) {
            Ok(outcome) => println!("--- outcome: {outcome}"),
            Err(panic) => {
                println!("--- guarded panic: {panic}");
                println!(
                    "--- known bug? {}",
                    gleam_core::redteam::is_known_compiler_bug(&panic)
                );
            }
        }
    }

    /// Every generated program must parse and type check on both targets
    /// and reach code generation. A failure here is a gleam-smith bug,
    /// not a gleam bug.
    #[test]
    fn generated_programs_compile_0_to_300() {
        for seed in 0..300u64 {
            let module = Module::from_seed(seed);
            let src = module.to_source();
            match gleam_core::redteam::probe_guarded(src.as_bytes()) {
                Ok(ProbeOutcome::Compiled { .. }) => {}
                Ok(outcome) => panic!(
                    "seed {seed} produced non-compiling program (outcome: {outcome}):\n{src}"
                ),
                Err(panic) if gleam_core::redteam::is_known_compiler_bug(&panic) => {
                    eprintln!("seed {seed}: known compiler bug ({panic}), tolerated");
                }
                Err(panic) => panic!(
                    "seed {seed} produced program that CRASHED the compiler: {panic}\n{src}"
                ),
            }
        }
    }
}
