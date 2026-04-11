# Workspaces, Working Copy, and Sparse Patterns

## Working-copy behavior

- Most `jj` commands snapshot working-copy changes automatically.
- New files are auto-tracked by default (controlled by `snapshot.auto-track`).
- Use `jj file track` / `jj file untrack` for explicit control.

## Multi-workspace workflow

Use multiple workspaces for parallel tasks (e.g., coding in one, long tests in another).

```bash
jj workspace list
jj workspace add ../repo-test --name test -r @-
jj workspace root --name test
jj workspace forget test
```

Each workspace has its own working-copy commit and sparse patterns.

## Stale working copy

A workspace can become stale (often due to rewrites from another workspace). Recover with:

```bash
jj workspace update-stale
```

## Sparse working copy

```bash
jj sparse list
jj sparse set --clear --add README.md --add src
jj sparse set --remove src/generated
jj sparse edit
jj sparse reset
```

Good for large repos or focused feature work.
