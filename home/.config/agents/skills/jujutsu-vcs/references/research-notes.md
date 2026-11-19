# Research Notes (How this skill was expanded)

## Local help-page scan

- Recursively scanned `jj --help` then every discovered command/subcommand `--help` page.
- Total scanned help pages: **114**.
- Exhaustive command tree captured in [command-tree.md](command-tree.md).

## Online docs scan

- Scanned docs sitemap at `https://docs.jj-vcs.dev/latest/sitemap.xml`.
- Total discovered pages: **52**.
- Used for workflow/context enrichment, especially:
  - operation log semantics and `--at-op`
  - first-class conflicts
  - divergent changes handling
  - working-copy + stale-workspace behavior
  - multiple remotes strategy
  - revsets/filesets/templates mental models

## External workflow articles

- Reasonably Polymorphic, “Jujutsu Strategies”: stacked PRs, optional empty `dev` base, bookmarks as publication handles, revset/log customization.
- Steve Klabnik, “Working on all of your branches simultaneously”: local merge integration changes for multiple PR heads, all-root rebases with `all:roots(...)`, cleanup of obsolete merged branches.
- Matt Hall, “Jujutsu From The Trenches”: top-of-relation-chain work plus `jj squash --into`, Gerrit `Change-Id` templates, cleanup of merged review chains, explicit base selection for new work.

## Helpful features added to skill references

- Graph surgery beyond basic rebase: `arrange`, `parallelize`, `simplify-parents`.
- Recovery depth: `op diff`, `op show`, `op restore`, `op revert`, `undo`/`redo`.
- Atomic cleanup tools: `absorb`, `split --parallel`, `restore --changes-in`, `revert`.
- Collaboration details: bookmark tracking semantics and push safety checks.
- Scalability: multi-workspace + sparse patterns + stale update handling.
- Automation: `fix`, `bisect run`, `file annotate/search`, `sign/unsign`, `util` helpers.
