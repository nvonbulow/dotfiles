# Jujutsu Skill References Index

This skill is intentionally split into focused files so agents can load only what they need.

## Start here

- [command-tree.md](command-tree.md) — exhaustive command/subcommand tree discovered from local `jj --help` scans.
- [research-notes.md](research-notes.md) — what was scanned (local help + docs site) and why.
- [workflows.md](workflows.md) — practical day-to-day and recovery workflows.
- [decision-matrix.md](decision-matrix.md) — task → command quick routing table.
- [failure-mode-matrix.md](failure-mode-matrix.md) — symptom → likely cause → fastest recovery.

## History rewriting and graph surgery

- [history-rewriting.md](history-rewriting.md) — atomic changesets, split/squash/absorb/restore/revert.
- [graph-operations.md](graph-operations.md) — rebase variants, arrange, parallelize, simplify-parents.
- [operation-log.md](operation-log.md) — undo/redo/op log/restore/revert/diff/show and `--at-op` usage.

## Collaboration and remotes

- [git-and-bookmarks.md](git-and-bookmarks.md) — bookmark tracking model, push/fetch safety, multiple remotes.
- [workspaces-and-sparse.md](workspaces-and-sparse.md) — multi-workspace, stale working copies, sparse checkouts.
- [conflicts-and-divergence.md](conflicts-and-divergence.md) — first-class conflicts and divergent change resolution.

## Query and inspection power tools

- [query-and-templates.md](query-and-templates.md) — revsets/filesets/templates and inspection commands.
- [specialized-tools.md](specialized-tools.md) — fix, bisect run, sign/unsign, gerrit, tags, file ops.

## External docs used

- Official docs root: https://docs.jj-vcs.dev/latest/
- CLI reference: https://docs.jj-vcs.dev/latest/cli-reference/
- Operation log: https://docs.jj-vcs.dev/latest/operation-log/
- Working copy: https://docs.jj-vcs.dev/latest/working-copy/
- Conflicts: https://docs.jj-vcs.dev/latest/conflicts/
- Divergence guide: https://docs.jj-vcs.dev/latest/guides/divergence/
- Multiple remotes guide: https://docs.jj-vcs.dev/latest/guides/multiple-remotes/
- Revsets/filesets/templates: https://docs.jj-vcs.dev/latest/revsets/ /filesets/ /templates/
