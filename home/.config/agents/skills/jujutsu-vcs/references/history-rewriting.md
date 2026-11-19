# Atomic Changesets and History Rewriting

## Goal

Prefer one intent per change. Use history edits to keep reviewable, bisectable commits.

## Core tools

### Split mixed commits

```bash
jj split -r <rev>           # interactive by default when no filesets
jj split -r <rev> --parallel
```

- `--parallel` creates sibling commits instead of parent/child.
- `-o/-A/-B` can extract selected hunks into a commit inserted elsewhere.

### Auto-fixup into ancestors

```bash
jj absorb
jj absorb --from <rev> --into 'mutable()'
jj absorb path/to/file
```

- Best for “small corrections in latest commit belong to older commits”.
- Review with `jj op show -p` or `jj show` after.

### Manual fixup movement

```bash
jj squash --from <source> --into <dest>
jj squash --from <source> --into <dest> -i
```

- Great when you know exact source/destination commit.
- Experimental alternative UI exists with `-o/-A/-B` forms.

### Restore vs revert

```bash
jj restore [paths]                # restore paths/parts from another rev
jj revert -r <rev> -o <dest>      # apply reverse of commit(s) as new change
```

- `restore` is path/content-oriented editing.
- `revert` is semantic reverse-commit creation.

### Duplicate and rephrase

```bash
jj duplicate -r <rev>
jj metaedit -r <rev>              # metadata only; can update change ID
jj describe -r <rev> -m "..."
```

Useful for preserving content while creating alternate lineage or resolving divergent-change situations.

## Recommended rewrite loop

```bash
jj status && jj log -n 20 && jj op log -n 5
# rewrite commands
jj status && jj log -n 20 && jj op log -n 5
```

If wrong: `jj undo` or `jj op restore <op-id>`.
