# Jujutsu Workflow Cookbook

## Minimal daily loop

```bash
jj status
jj log -n 10
# edit files
jj commit -m "<message>"
jj log -n 10
```

## Start unrelated work from the intended base

Do not start new unrelated work from whatever `@` happens to be.

If the repo uses a local `dev` bookmark/base workflow, start from `dev`:

```bash
jj new dev -m "<message>"
```

Otherwise start from the repo's trunk revset:

```bash
jj new trunk() -m "<message>"
# or when the repo convention is an explicit bookmark:
jj new main -m "<message>"
```

Verify before editing:

```bash
jj log -n 15
```

## Top-of-stack fixups

When a small correction belongs in an earlier change, keep working at the stack head and move the edit backward:

```bash
jj squash --into <target-rev>
jj squash --into <target-rev> -i
```

Use automatic line-based redistribution when edits clearly match mutable ancestors:

```bash
jj absorb
jj absorb path/to/file
```

Verify the affected change:

```bash
jj show <target-rev>
jj log -n 20
```

## Split one commit into two atomic commits

```bash
jj split -r <rev>
jj describe -r <new-rev-1> -m "..."
jj describe -r <new-rev-2> -m "..."
```

## Move accidental fixups into earlier commits

```bash
jj absorb
# if needed, repeat with path filters
jj absorb path/to/file
```

## Move changes from one commit to another manually

```bash
jj squash --from <source-rev> --into <dest-rev>
```

## Stacked PR / relation-chain review loop

```bash
jj log -n 30
# make review fix at stack head
jj squash --into <reviewed-rev> -i
# or, when line ownership is obvious:
jj absorb
jj log -n 30
```

Use bookmarks as publication handles, not as required local work containers:

```bash
jj bookmark create -r <review-head> <name>
jj git push --remote origin --bookmark <name>
```

After a reviewed change lands upstream, fetch and clean up the obsolete local review chain:

```bash
jj git fetch --remote origin
jj abandon -r <merged-local-root>::
jj log -n 30
```

## Reorder commits in a stack

```bash
jj rebase -r <rev> -A <target>   # place after
jj rebase -r <rev> -B <target>   # place before
```

## Recover from mistakes

```bash
jj op log -n 20
jj undo                  # last operation only
jj op restore <op-id>    # restore repo state to earlier operation
```

Inspect repository at old operation first:

```bash
jj --at-op=<op-id> --ignore-working-copy log -n 20
```

## Useful inspection commands

```bash
jj show <rev>
jj diff -r <rev>
jj evolog -r <rev>
jj op show <op-id>
```

## Suggested agent checklist before/after rewriting history

Before:

```bash
jj status
jj log -n 20
jj op log -n 5
```

After:

```bash
jj status
jj log -n 20
jj op log -n 5
```

If anything looks off, stop and recover via `jj undo` or `jj op restore`.
