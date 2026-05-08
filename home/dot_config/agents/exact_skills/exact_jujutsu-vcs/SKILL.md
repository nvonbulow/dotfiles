---
name: jujutsu-vcs
description: Use Jujutsu (jj) for day-to-day version control, history surgery, and recovery. Use when a task involves creating atomic changesets, rebasing/reordering stacked work, squashing or absorbing fixups, inspecting or restoring via the operation log, and syncing with Git remotes/bookmarks.
---

# Jujutsu VCS Skill

Use this skill when working in a `jj` repository (`.jj/` exists) and the user asks for version-control operations.

Prefer `jj` over `git` unless the user explicitly requests `git`.

To keep context compact, load only the relevant reference file(s) from [references/index.md](references/index.md) for the task.

## Agent Cheat Sheet

Load this top-level file first. For routine work, use the commands below directly; load a reference file only when the task needs detail beyond the cheat sheet.

### First look / safety snapshot

```bash
jj status
jj log -n 12
jj op log -n 8
```

If state is confusing, inspect old operations without changing the working copy:

```bash
jj --at-op=<op-id> --ignore-working-copy log -n 20
jj --at-op=<op-id> --ignore-working-copy status
```

### Start or finish work

```bash
# New unrelated work: prefer dev when the repo uses the local dev-base workflow.
jj new dev -m "<message>"

# Otherwise start from the repo trunk revset / explicit main bookmark.
jj new trunk() -m "<message>"
jj new main -m "<message>"

# Commit current working-copy change, leaving a new empty @.
jj commit -m "<message>"

# Rename/describe the current change without committing it.
jj describe -m "<message>"
```

### Shape atomic changes

```bash
# Split mixed work into reviewable changes.
jj split -r @
jj describe -r <rev> -m "<message>"

# Move current fixups back into the owning earlier change.
jj absorb
jj squash --into <target-rev>
jj squash --into <target-rev> -i

# Inspect what changed.
jj show <rev>
jj diff -r <rev>
```

### Move stacks / graph surgery

```bash
# Move the current stack to a new base.
jj rebase -b @ -o <new-base>

# Move only one commit, preserving descendants separately.
jj rebase -r <rev> -o <new-parent>

# Insert one commit before/after another.
jj rebase -r <rev> -A <target>
jj rebase -r <rev> -B <target>

# Rebase all active roots after trunk moves.
jj rebase -s 'all:roots(trunk()..@)' -o trunk()
```

### Conflicts and recovery

```bash
# See and resolve conflicts.
jj status
jj resolve --list
jj resolve <path>

# Fast recovery.
jj undo
jj redo
jj op log -n 20
jj op restore <op-id>
```

### Sync and publish

```bash
jj git fetch --remote origin
jj bookmark list --all
jj git push --remote origin --dry-run
jj git push --remote origin --bookmark <name>
jj git push --remote origin --change <rev>
```

### Reference routing

| Need | Load |
|---|---|
| Task-to-command choice | [decision-matrix.md](references/decision-matrix.md) |
| Surprise/error recovery | [failure-mode-matrix.md](references/failure-mode-matrix.md) |
| Daily workflows/fixups/review loops | [workflows.md](references/workflows.md) |
| Splits/squash/absorb/restore/revert | [history-rewriting.md](references/history-rewriting.md) |
| Rebases/stacks/topology/integration merges | [graph-operations.md](references/graph-operations.md) |
| Git remotes/bookmarks/publishing | [git-and-bookmarks.md](references/git-and-bookmarks.md) |
| Revsets/templates/inspection | [query-and-templates.md](references/query-and-templates.md) |
| Workspaces/sparse/stale workspaces | [workspaces-and-sparse.md](references/workspaces-and-sparse.md) |

## Core Principles

1. **Edits are already tracked in the working-copy changeset** (`@`); there is no separate staging area.
2. **Every logical intent should end up as an atomic changeset**.
3. **History is malleable** in `jj`; rewrite confidently, then verify.
4. **Operation log is your safety net**: almost every mistake is recoverable.
5. **Check graph before and after mutation**.
6. **Start unrelated work from the intended base**: use `dev` if the repository uses the local dev-base workflow; otherwise use `trunk()`/`main` by repo convention.

## Quick Triage (run first)

```bash
jj status
jj log -n 12
jj op log -n 8
```

If the repo state is confusing, inspect historical view without mutating working copy:

```bash
jj --at-op=<op-id> --ignore-working-copy log -n 20
jj --at-op=<op-id> --ignore-working-copy status
```

## Agent Workflows

### 1) Safe mutation workflow (default for any non-trivial history edit)

1. Inspect baseline:
   ```bash
   jj status
   jj log -n 15
   jj op log -n 5
   ```
2. Announce planned rewrite in plain language.
3. Execute rewrite command(s) (`split`, `rebase`, `squash`, `absorb`, etc.).
4. Verify results:
   ```bash
   jj status
   jj log -n 15
   jj op log -n 5
   ```
5. If result is wrong, recover with `jj undo` (immediate) or `jj op restore <op-id>` (targeted rollback).

### 2) Build atomic changesets from mixed work

When current working copy contains multiple concerns:

1. Start by inspecting what is already in `@`:
   ```bash
   jj status
   jj show @
   ```
2. Split the current mixed changeset into focused commits:
   ```bash
   jj split -r @
   ```
   - Use interactive split to separate hunks by concern.
3. Refine commit messages:
   ```bash
   jj describe -r <rev> -m "feat: ..."
   jj describe -r <rev> -m "fix: ..."
   ```
4. Reorder/reparent if needed:
   ```bash
   jj rebase -r <rev> -A <target>
   # or
   jj rebase -r <rev> -B <target>
   ```

### 3) Start unrelated work from the right base

Before starting a new, unrelated task, do not blindly continue from current `@`.

If the repository uses the optional local `dev` bookmark/base workflow, start from `dev`:

```bash
jj new dev -m "<message>"
```

Otherwise start from the repo's trunk revset:

```bash
jj new trunk() -m "<message>"
# or, when the repo convention is an explicit bookmark:
jj new main -m "<message>"
```

Verify the parent before editing:

```bash
jj log -n 15
```

### 4) Fixup workflow with absorb/squash

Use when a later commit contains corrections that belong in earlier commits.

Default to working at the stack head and moving edits backward, instead of interrupting the workspace with `jj edit <old-rev>`, when the fix is small and clearly belongs to an earlier change.

- **Automatic line-based fixup into ancestors:**
  ```bash
  jj absorb
  ```
  Optional scope:
  ```bash
  jj absorb path/to/file
  jj absorb --from <rev> --into 'mutable()'
  ```

- **Manual targeted movement:**
  ```bash
  jj squash --from <source-rev> --into <dest-rev>
  ```
  Interactive partial squash:
  ```bash
  jj squash --from <source-rev> --into <dest-rev> -i
  ```

After either command, verify:

```bash
jj log -n 20
jj show <affected-rev>
```

### 5) Operation-log recovery workflow (must know)

Use for accidental rebase/squash/abandon, or "where did my work go?"

1. Inspect operation history:
   ```bash
   jj op log -n 20
   ```
2. Inspect a past point-in-time:
   ```bash
   jj --at-op=<op-id> --ignore-working-copy log -n 30
   ```
3. Recover:
   - Fast rollback of last op:
     ```bash
     jj undo
     ```
   - Restore to any earlier op by creating a new operation:
     ```bash
     jj op restore <op-id>
     ```
4. Confirm restored graph and workspace state:
   ```bash
   jj log -n 20
   jj status
   ```

### 6) Optional local dev-base workflow

Use this when maintaining several local branches/stacks at once or when local-only developer setup should sit below all active work. Keep `dev` empty unless the user explicitly wants local-only changes there.

Create or move active work to fan out from `dev`:

```bash
jj new trunk()
jj bookmark set dev
jj new dev -m "<feature message>"
```

After upstream changes land, rebase only `dev`; descendants follow:

```bash
jj git fetch --remote origin
jj rebase -r dev -o trunk()
jj log -n 30
```

With this workflow active, new unrelated work should start from `dev`, not `main`/`trunk`.

### 7) Stacked-change maintenance

For a stack of dependent commits:

```bash
jj log -n 30
jj rebase -b @ -o <new-base>
```

For precise surgery on one commit without moving whole descendant tree:

```bash
jj rebase -r <rev> -o <new-parent>
```

For conflict resolution after rebase:

```bash
jj resolve
jj status
```

### 8) Git remote sync with bookmarks

Typical sync loop:

```bash
jj git fetch --remote origin
jj bookmark list
jj git push --remote origin
```

Push only selected bookmarks:

```bash
jj git push --remote origin --bookmark <name>
```

Push by change ID using generated bookmark:

```bash
jj git push --remote origin --change <rev>
```

## Guardrails

- Do not run destructive filesystem commands to "fix" VCS confusion; use `jj op log` first.
- Prefer `jj undo`/`jj op restore` over ad-hoc compensating history rewrites.
- In non-interactive/background runs (agents, CI, `bash` jobs), avoid commands that open an editor prompt.
  - Use explicit message flags, e.g. `jj squash --into @- -m "..."`, `jj describe -m "..."`.
  - Otherwise `jj` may launch `$EDITOR` (often `nano`/`pico`) and fail/hang with `Failed to edit description`.
- Do not assume a “stage then commit” model; in `jj`, edits are already recorded in `@`.
- Before pushing rewritten history, always run:
  ```bash
  jj git fetch --remote <remote>
  jj log -n 20
  jj bookmark list
  ```
- If immutable-commit errors appear, stop and ask before using `--ignore-immutable`.

## References

Start with [reference index](references/index.md).

For exhaustive command discovery from local help pages, see:
- [command-tree.md](references/command-tree.md)

For practical runbooks, see:
- [workflows.md](references/workflows.md)
- [operation-log.md](references/operation-log.md)
- [history-rewriting.md](references/history-rewriting.md)
- [graph-operations.md](references/graph-operations.md)
