# Operation Log and Recovery

Use this when anything looks wrong after rewriting history.

## Key model

- `jj` records every mutating action in the **operation log**.
- Recovery is usually additive (new operation), not destructive.
- Docs context: operation log records repo view, bookmarks/tags/heads, and workspace working-copy pointers.

## Core commands

```bash
jj op log -n 20              # operation timeline
jj op show <op-id>           # inspect a single operation
jj op diff --from A --to B   # compare repo state between ops
jj undo                       # undo most recent operation
jj redo                       # redo most recent undone operation
jj op restore <op-id>         # restore whole repo state to an earlier op (new op)
jj op revert <op-id>          # revert the effects of one operation (new op)
```

## Point-in-time inspection (non-mutating view)

```bash
jj --at-op=<op-id> --ignore-working-copy log -n 30
jj --at-op=<op-id> --ignore-working-copy status
```

`--at-op` is often the safest way to investigate before changing anything.

## Recovery playbook

1. `jj op log -n 30`
2. Inspect suspect points via `jj --at-op=<op> ...`
3. Choose one:
   - last command only: `jj undo`
   - full rollback to a known-good point: `jj op restore <op-id>`
   - inverse of one specific operation: `jj op revert <op-id>`
4. Verify with:
   ```bash
   jj log -n 20
   jj status
   jj op log -n 10
   ```

## Notes

- `operation restore/revert --what ...` exists and is marked experimental.
- `operation integrate` exists but is generally a maintenance/no-op command unless debugging corruption scenarios.
