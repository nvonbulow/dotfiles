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


## Bookmarks as publication handles

Local changes do not need bookmark names while they are being shaped. Add or move a bookmark at the review/shipping boundary:

```bash
jj bookmark create -r <review-head> <name>
jj git push --remote origin --bookmark <name>
```

For stacked PRs, bookmark the head of each reviewable boundary. Review fixes can be moved into earlier changes with `jj squash --into <rev> -i` or `jj absorb`; descendants update automatically.

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

## Cleanup after merge

After fetching upstream, old local review changes may remain as duplicate/obsolete changes. Inspect first, then abandon the merged local chain:

```bash
jj git fetch --remote origin
jj log -n 30
jj abandon -r <merged-local-root>::
```

If only a bookmark/review head is obsolete:

```bash
jj abandon <old-bookmark-or-change>
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
