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
