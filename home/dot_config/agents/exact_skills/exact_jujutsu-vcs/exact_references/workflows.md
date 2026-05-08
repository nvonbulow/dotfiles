# Jujutsu Workflow Cookbook

## Minimal daily loop

```bash
jj status
jj log -n 10
# edit files
jj commit -m "<message>"
jj log -n 10
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
