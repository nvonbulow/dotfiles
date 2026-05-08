# Graph Operations (Stacks, Reparenting, Topology)

## Rebase modes

```bash
jj rebase -b <revset> -o <dest>   # whole branch relative to destination
jj rebase -s <revset> -o <dest>   # source(s) + descendants
jj rebase -r <revset> -o <dest>   # only selected revisions, preserve holes
```

Insertion variants:

```bash
jj rebase -r <rev> -A <target>     # insert after
jj rebase -r <rev> -B <target>     # insert before
```

Useful options:

- `--skip-emptied`
- `--keep-divergent`
- `--simplify-parents`


## Local dev-base workflow

Use an empty `dev` bookmark as a local fanout point when maintaining several active stacks. If this workflow is active, start unrelated work from `dev`; otherwise start from `trunk()`/repo main.

```bash
jj new trunk()
jj bookmark set dev
jj new dev -m "<feature message>"
```

After fetching upstream updates, move `dev`; descendants rebase with it:

```bash
jj git fetch --remote origin
jj rebase -r dev -o trunk()
jj log -n 30
```

## Simultaneous multi-branch integration

To test or edit several active PR heads together, create a local merge integration change and work above it:

```bash
jj new <pr1-head> <pr2-head> <pr3-head> -m "merge: local integration"
jj new
```

Redistribute fixes back to the owning branch/change:

```bash
jj absorb
jj squash --into <target-rev> -i
```

If one branch gets a new head, rebase the integration merge onto the updated parent set:

```bash
jj rebase -r <integration-rev> -o <pr1-head> -o <pr2-new-head> -o <pr3-head>
```

After upstream moves, rebase all active roots under the current integration workspace:

```bash
jj git fetch --remote origin
jj rebase -s 'all:roots(trunk()..@)' -o trunk()
jj log -n 30
```

Use `all:` only when the revset intentionally resolves to multiple roots.

## Specialized topology tools

### `jj arrange`

Interactive commit-graph arranging over selected revset (`revsets.arrange` default). Use when reordering many commits is easier graphically than repeated rebases.

### `jj parallelize`

Make selected commits siblings (declare independence), while preserving ancestry constraints from nodes outside selection.

### `jj simplify-parents`

Remove redundant parent edges in merges, without changing commit contents. Good cleanup after complex rebases/merges.

## Stack maintenance examples

```bash
# move full stack to new base
jj rebase -b @ -o <new-base>

# reorder one commit later
jj rebase -r <rev> -A <target>

# clean redundant parent edges after surgery
jj simplify-parents -s <stack-root>
```

Always verify with `jj log -n 30` and recover with operation-log tools if needed.
