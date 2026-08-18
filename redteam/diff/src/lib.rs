// SPDX-License-Identifier: Apache-2.0
// SPDX-FileCopyrightText: 2026 The Gleam contributors

//! Differential-oracle normaliser.
//!
//! Converts one target's raw `gleam run` output into the set of
//! value-shaped lines the program actually printed. Replaces the
//! awk/sed/grep pipeline that previously lived in `redteam/bin/diff-run.sh`.
//!
//! Pipeline, in order (must match the old bash exactly):
//!   1. strip ANSI colour codes
//!   2. drop warning blocks (`warning:` line .. blank line)
//!   3. drop the per-target echo source-location line
//!   4. whitelist value-shaped lines (Int, String, Bool, List, Tuple,
//!      BitArray, constructor)
//!   5. canonicalise whole-valued floats (`1.0` -> `1`)
//!   6. strip trailing whitespace

use regex::Regex;

/// Regexes are compiled once; the normaliser is hot (called once per
/// generated program).
struct Normaliser {
    ansi: Regex,
    echo_location: Regex,
    value_shape: Regex,
    whole_float: Regex,
    trailing_ws: Regex,
}

impl Normaliser {
    fn new() -> Self {
        let value_shape = Regex::new(
            r#"^-?[0-9]+$|^-?[0-9]+\.[0-9]+$|^".*"*$|^(True|False)$|^\[.*\]$|^#\(.*\)$|^<<.*>>$|^[A-Z][A-Za-z0-9_]*(\(.*\))?$"#,
        )
        .expect("value-shape regex compiles");
        Self {
            ansi: Regex::new(r"\x1b\[[0-9;]*m").expect("ansi regex compiles"),
            echo_location: Regex::new(r"main\.gleam:[0-9]+").expect("echo-location regex compiles"),
            value_shape,
            whole_float: Regex::new(r"^(-?[0-9]+)\.0$").expect("whole-float regex compiles"),
            trailing_ws: Regex::new(r"[[:space:]]+$").expect("trailing-ws regex compiles"),
        }
    }

    /// Run the full pipeline over raw output. Returns the lines a program
    /// actually printed, in order.
    fn normalise(&self, raw: &str) -> Vec<String> {
        let mut lines = Vec::new();
        let mut in_warning = false;
        for line in raw.lines() {
            let line = self.ansi.replace_all(line, "").into_owned();

            // Warning blocks: a line starting with `warning:` starts a block
            // that continues until (and includes) the next blank line.
            if in_warning {
                if line.trim_end().is_empty() {
                    in_warning = false;
                }
                continue;
            }
            if line.starts_with("warning:") {
                in_warning = true;
                continue;
            }

            // Drop the per-target echo source-location line.
            if self.echo_location.is_match(&line) {
                continue;
            }

            // Keep only value-shaped lines.
            if !self.value_shape.is_match(&line) {
                continue;
            }

            // Canonicalise whole-valued floats so both backends agree.
            let line = self.whole_float.replace_all(&line, "$1").into_owned();
            // Strip trailing whitespace.
            let line = self.trailing_ws.replace_all(&line, "").into_owned();

            lines.push(line);
        }
        lines
    }
}

/// Normalise raw output into the value lines a program printed.
pub fn normalise(raw: &str) -> Vec<String> {
    Normaliser::new().normalise(raw)
}

#[cfg(test)]
mod tests {
    use super::normalise;

    #[test]
    fn strips_ansi_codes() {
        let out = normalise("\x1b[90msrc/main.gleam:2\x1b[39m\n42\n");
        assert_eq!(out, vec!["42"]);
    }

    #[test]
    fn drops_warning_blocks() {
        let out = normalise("warning: Unused private function\n  with\n  details\n\n42\n");
        assert_eq!(out, vec!["42"]);
    }

    #[test]
    fn drops_echo_source_location_line() {
        let out = normalise("src/main.gleam:2\n42\n");
        assert_eq!(out, vec!["42"]);
    }

    #[test]
    fn keeps_value_shapes() {
        let raw = "42\n-7\n1.5\n\"hello\"\nTrue\nFalse\n[1, 2]\n#(1, \"a\")\n<<1, 2>>\nCv1(1)\nSome\n";
        let out = normalise(raw);
        assert_eq!(
            out,
            vec![
                "42", "-7", "1.5", "\"hello\"", "True", "False", "[1, 2]", "#(1, \"a\")",
                "<<1, 2>>", "Cv1(1)", "Some",
            ]
        );
    }

    #[test]
    fn drops_non_value_lines() {
        let raw = "  Compiling app\n   Compiled in 0.22s\n    Running main.main\n42\nHint: try again\n";
        let out = normalise(raw);
        assert_eq!(out, vec!["42"]);
    }

    #[test]
    fn canonicalises_whole_floats() {
        let out = normalise("1.0\n50.0\n0.0\n1.5\n0.30000000000000004\n");
        assert_eq!(out, vec!["1", "50", "0", "1.5", "0.30000000000000004"]);
    }

    #[test]
    fn strips_trailing_whitespace() {
        // `42  ` is dropped: trailing spaces break the integer whitelist
        // anchor, matching the old grep pipeline. `"x"  ` survives because
        // the string shape allows trailing content, then gets trimmed.
        let out = normalise("42  \n\"x\"  \n");
        assert_eq!(out, vec!["\"x\""]);
    }

    #[test]
    fn empty_input_yields_no_lines() {
        assert_eq!(normalise(""), Vec::<String>::new());
    }

    #[test]
    fn multiple_warning_blocks() {
        let raw = "warning: First\n\n1\nwarning: Second\nmore\n\n2\n";
        let out = normalise(raw);
        assert_eq!(out, vec!["1", "2"]);
    }
}