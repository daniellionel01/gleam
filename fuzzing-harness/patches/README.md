# Patches

This directory contains patches for known issues in the Gleam compiler or
downstream tooling that we want to filter out when fuzzing.

Each patch is:
- A `git apply`able diff (`<name>.patch`)
- A metadata file (`<name>.toml`) with the upstream issue/PR URLs and the
  expected sha256 hashes of every source file the patch touches

## Why

The fuzz binary `fuzz` detects divergences between the Erlang and JavaScript
backends. When a known issue (in Gleam or in Erlang/OTP) causes a divergence
on every seed, we don't want to keep reporting it forever. The options are:

1. **String matching** — fragile, breaks when error messages change, can
   catch unrelated errors that happen to share a string.
2. **Apply the upstream fix as a local patch** — runs the actual fix, so we
   exercise the patched compiler. If the patch can't apply (file hash
   changed), we know the issue was resolved upstream.

This directory uses option 2.

## How `gleam-patch` works

`gleam-patch apply` walks every `.toml` file in this directory:

1. For each `expected_hash.path`, compute the sha256 of the current source.
   - If it matches the recorded hash, the upstream file is unchanged → apply
     the patch with `git apply`.
   - If it doesn't match, the upstream file has been modified (PR merged,
     refactor, etc.). Skip the patch and report it as resolved. The fuzz
     binary no longer needs to filter for this issue.

2. After applying patches, rebuild `gleam-cli` so the fuzz binary picks up
   the local Gleam.

3. The fuzz binary prefers `target/release/gleam` from this repo over the
   system-installed `gleam` when `gleam-patch apply` has been run.

## Why hashes?

The hashes are recorded at the time the patch is captured. They detect:
- PR merged upstream → file rewritten → hash mismatch → patch skipped
- File refactored → hash mismatch → patch skipped, manual review needed
- File unchanged → patch applies → fuzzing runs against patched Gleam

This means we never silently filter against stale heuristics. Either the
patch applies cleanly (and we run against the patched binary), or it
doesn't (and we know to re-evaluate).

## Adding a patch

```
# 1. Download the PR diff
gh pr diff <N> > patches/<N>.patch

# 2. Strip CHANGELOG entries, test additions, and snapshot files - we only
#    want the source fix.
#    (The fuzz branch's CHANGELOG.md has drifted from main, so any
#    CHANGELOG hunk in the PR will fail to apply.)

# 3. Capture hashes for every file the patch modifies
sha256sum <files>

# 4. Write the metadata
cat > patches/<N>.toml <<EOF
issue = "https://github.com/.../issues/N"
pr = "https://github.com/.../pull/N"
description = "..."
patch = "N.patch"

[[expected_hash]]
path = "..."
sha256 = "..."
EOF

# 5. Test
./target/release/gleam-patch status
./target/release/gleam-patch apply
```

## Current patches

| Issue | PR | Status |
|-------|----|--------|
| gleam #6182 (JS empty bit array segment codegen) | gleam #6186 | hash matches; patch truncated in PR diff - see note |