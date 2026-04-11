# Conflicts and Divergent Changes

## First-class conflicts (docs concept)

Jujutsu can store conflicted states in commits. Rebase/merge operations can succeed even with unresolved conflicts, and you resolve when ready.

Typical workflow:

```bash
jj status
jj resolve                 # external merge tool when applicable
jj diff
jj squash                  # move resolution into target commit when using a helper commit
```

Or directly edit conflicted commit with `jj edit <rev>`.

## Divergent changes

Divergent change = multiple visible commits share one change ID.

Resolution strategies (docs guide):

1. Abandon one side:
   ```bash
   jj abandon <rev>
   ```
2. Keep both but assign new change ID:
   ```bash
   jj metaedit --update-change-id <rev>
   ```
3. Merge content into one:
   ```bash
   jj squash --from <rev-a> --into <rev-b>
   ```
4. Leave as-is (acceptable in some immutable scenarios).

When targeting divergent commits in revsets, use commit IDs or change ID offsets like `<change>/0`, `<change>/1`.
