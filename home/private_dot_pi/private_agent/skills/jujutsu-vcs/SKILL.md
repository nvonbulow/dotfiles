---
name: jujutsu-vcs
description: Use Jujutsu (jj) for day-to-day version control, history surgery, and recovery. Use when a task involves creating atomic changesets, rebasing/reordering stacked work, squashing or absorbing fixups, inspecting or restoring via the operation log, and syncing with Git remotes/bookmarks.
---

# Jujutsu VCS Skill

Use this skill when working in a `jj` repository (`.jj/` exists) and the user asks for version-control operations.

Prefer `jj` over `git` unless the user explicitly requests `git`.

To keep context compact, load only the relevant reference file(s) from [references/index.md](references/index.md) for the task.

## Core Principles

1. **Every edit should land in an atomic changeset** (single intent per change).
2. **History is malleable** in `jj`; rewrite confidently, then verify.
3. **Operation log is your safety net**: almost every mistake is recoverable.
4. **Check graph before and after mutation**.

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

1. Commit current snapshot to anchor work:
   ```bash
   jj commit -m "wip: mixed changes"
   ```
2. Split into focused commits:
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

### 3) Fixup workflow with absorb/squash

Use when a later commit contains corrections that belong in earlier commits.

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

### 4) Operation-log recovery workflow (must know)

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

### 5) Stacked-change maintenance

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

### 6) Git remote sync with bookmarks

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
