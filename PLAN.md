# Variable Shadowing Toggle Feature - Implementation Plan

## Overview

Add a configuration option `forbid_shadowing` that, when enabled, produces warnings when:
1. A local variable shadows another variable in scope
2. A top-level definition shadows an import

Users can enable it in `gleam.toml`:
```toml
forbid_shadowing = true
```

Or via CLI:
```bash
gleam build --forbid-shadowing
```

## Implementation Phases

### Phase 1: Configuration

- [x] **1.1 Add `forbid_shadowing` field to `PackageConfig`** (`compiler-core/src/config.rs`)
  - Add field to struct around line 183-184
  - Add to `Default` implementation around line 710

- [x] **1.2 Verify config changes compile**
  - Run `cargo check -p gleam-core`
  - Fix any issues

### Phase 2: Warning Types

- [x] **2.1 Add new warning variant** (`compiler-core/src/type_/error.rs`)
  - Add `LocalVariableShadowsVariable { location: SrcSpan, name: EcoString, previous_location: SrcSpan }` to the `Warning` enum
  - Update `Warning::location()` method

- [x] **2.2 Add diagnostic formatting** (`compiler-core/src/warning.rs`)
  - Add formatting for the new warning type in the `Warning` to `Diagnostic` conversion

### Phase 3: Build Pipeline

- [x] **3.1 Add to `Options` struct** (`compiler-core/src/build/project_compiler.rs`)
  - Add `forbid_shadowing: bool` field to `Options` struct (around line 58-67)

- [x] **3.2 Pass through `ProjectCompiler`**
  - Store the option in `ProjectCompiler` struct
  - Pass to package compiler

- [x] **3.3 Pass through `PackageCompiler`** (`compiler-core/src/build/package_compiler.rs`)
  - Pass the setting to the type checker/analyser

### Phase 4: Shadowing Detection

- [x] **4.1 Modify `insert_local_variable`** (`compiler-core/src/type_/environment.rs`)
  - Change return type to optionally return the shadowed variable's location
  - Check if variable already exists in scope before inserting
  - Return previous location if shadowing

- [x] **4.2 Wire up warning emission** (`compiler-core/src/type_/expression.rs`)
  - At call sites of `insert_local_variable`, check return value
  - If shadowing detected and `forbid_shadowing` is enabled, emit warning

- [x] **4.3 Handle pattern variables** (`compiler-core/src/type_/pattern.rs`)
  - Similar changes for pattern variable insertion
  - Emit warning when pattern variable shadows existing variable

- [x] **4.4 Make `TopLevelDefinitionShadowsImport` conditional** (`compiler-core/src/analyse.rs`)
  - Modify `check_shadow_import` function (around line 1721-1734)
  - Only emit warning when `forbid_shadowing` is enabled

### Phase 5: CLI Support

- [x] **5.1 Add CLI flag** (`compiler-cli/src/lib.rs`)
  - Add `--forbid-shadowing` flag to `Build` command (around line 150-161)
  - Pass to build options

- [x] **5.2 Wire through build command** (`compiler-cli/src/build.rs`)
  - Pass the flag value to `Options`

### Phase 6: LSP Support

- [x] **6.1 Read from config** (`language-server/src/compiler.rs`)
  - The LSP should read `forbid_shadowing` from `PackageConfig` (which comes from `gleam.toml`)
  - Pass to `build::Options` (around line 67-75)

### Phase 7: Tests

- [x] **7.1 Add warning tests** (`compiler-core/src/type_/tests/warnings.rs`)
  - Test local variable shadowing warning
  - Test that shadowing is allowed when disabled
  - Test import shadowing warning

- [x] **7.2 Add config tests** (`compiler-core/src/config.rs`)
  - Test deserialization of `forbid_shadowing` from TOML
  - Test default value is `false`

## Key Files Modified

| File | Changes |
|------|---------|
| `compiler-core/src/config.rs` | Add `forbid_shadowing` field to `PackageConfig` and `Default` |
| `compiler-core/src/type_/error.rs` | Add `LocalVariableShadowsVariable` warning variant |
| `compiler-core/src/warning.rs` | Add diagnostic formatting |
| `compiler-core/src/build/project_compiler.rs` | Add to `Options` struct |
| `compiler-core/src/build/package_compiler.rs` | Pass setting to analyser |
| `compiler-core/src/type_/environment.rs` | Detect shadowing in `insert_local_variable` |
| `compiler-core/src/type_/expression.rs` | Emit warning at call sites |
| `compiler-core/src/type_/pattern.rs` | Handle pattern variable shadowing |
| `compiler-core/src/analyse.rs` | Make import shadowing warning conditional |
| `compiler-cli/src/lib.rs` | Add `--forbid-shadowing` CLI flag |
| `language-server/src/compiler.rs` | Read setting from config |
| `compiler-core/src/type_/tests/warnings.rs` | Add tests |
| `compiler-core/src/type_/tests.rs` | Add test infrastructure for forbid_shadowing |
| `compiler-core/src/type_/tests/dead_code_detection.rs` | Update tests for conditional shadow warning |

## Notes

- The existing `TopLevelDefinitionShadowsImport` warning is now only emitted when `forbid_shadowing` is enabled
- Local variable shadowing is now optionally warned about when `forbid_shadowing` is enabled
- The `_` prefix for unused variables does NOT trigger shadowing warnings (those are intentional)
