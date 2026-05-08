# Git Remotes and Bookmarks

## Bookmark model highlights

- Bookmarks are movable named pointers (branch-like).
- Local bookmark can track remote bookmark(s) of same name.
- Push safety is similar to `--force-with-lease` semantics.

Useful commands:

```bash
jj bookmark list --all
jj bookmark track <name> --remote <remote>
jj bookmark untrack <name> --remote <remote>
```

## Daily sync loop

```bash
jj git fetch --remote origin
jj bookmark list
jj git push --remote origin
```

Selective push patterns:

```bash
jj git push --remote origin --bookmark <name>
jj git push --remote origin --tracked
jj git push --remote origin --change <rev>
jj git push --remote origin --dry-run
```

## Remote strategy notes (from docs)

For fork workflows (`origin` + `upstream`), consider:

```bash
jj config set --repo git.fetch '["upstream", "origin"]'
jj config set --repo git.push origin
jj bookmark track main
jj config set --repo 'revset-aliases."trunk()"' main@upstream
```

For independent repo integrating upstream, tracking policy differs: track/push primarily against `origin`; integrate from `upstream` intentionally.

## Colocation and import/export

- `jj git clone` defaults to colocated mode (Git and JJ tools in same dir).
- `jj git colocation {status,enable,disable}` manages this mode.
- `jj git import`/`jj git export` sync with underlying Git data when needed.

## Conflict handling hints

- Bookmark conflicts show up in `jj status` and `jj bookmark list`.
- Resolve local bookmark conflicts with `jj bookmark move` or graph operations before pushing.
