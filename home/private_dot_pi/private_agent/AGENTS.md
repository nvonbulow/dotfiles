# Global agent instructions

## Version control defaults

- Prefer `jj` (Jujutsu) over `git` for all version-control operations.
- Use `git` only when:
  - the user explicitly asks for Git, or
  - a required operation is not available in `jj`.

## Repositories without Jujutsu

- If the current repository is a Git repo but is not initialized for Jujutsu (`.jj/` missing), ask the user before proceeding:
  - "This repo is not initialized for Jujutsu. Do you want me to run `jj git init` first?"
- Do not run `jj git init` unless the user confirms.

## Safe mutation workflow (for non-trivial history edits)

Before edits:
- `jj status`
- `jj log -n 12`
- `jj op log -n 8`

After edits:
- `jj status`
- `jj log -n 12`
- `jj op log -n 8`

If anything looks wrong, recover with:
- `jj undo` (immediate last-op rollback)
- `jj op restore <op-id>` (targeted restore)
