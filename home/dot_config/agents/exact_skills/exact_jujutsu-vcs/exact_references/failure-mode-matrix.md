# Failure-Mode Matrix (Symptom → Cause → Fast Recovery)

Use this when `jj` behavior seems surprising.

| Symptom | Likely cause | Fastest recovery / next step |
|---|---|---|
| “My commits disappeared” | History was rewritten; old commits became hidden | `jj op log -n 20` → inspect old state with `jj --at-op=<id> --ignore-working-copy log -n 30` |
| “Latest command messed up history” | Bad rebase/squash/split args | `jj undo` (then `jj redo` if needed) |
| “Need to go back to exactly how repo looked earlier” | Multiple subsequent bad operations | `jj op restore <op-id>` |
| “Need to negate one specific operation, not all later ones” | One op in the middle was wrong | `jj op revert <op-id>` |
| “`@` points somewhere unexpected” | Different operation/workspace view | `jj status`, `jj workspace list`, optionally inspect with `--at-op=<id>` |
| “Another workspace now looks stale” | Commit rewritten from a different workspace | `jj workspace update-stale` |
| “Bookmark has `??` or push refuses” | Bookmark conflict due to local+remote updates | `jj bookmark list --all` then `jj bookmark move ...`, re-fetch, push again |
| “Push rejected despite being correct locally” | Remote moved since last fetch / lease safety check | `jj git fetch --remote <r>` → resolve bookmark conflicts → retry push |
| “Can’t refer to change ID (ambiguous/divergent)” | Multiple visible commits share change ID | Use commit IDs or `<change>/0`, `<change>/1`; resolve via `abandon`, `metaedit --update-change-id`, or `squash` |
| “Unexpected conflicts after rebase” | Legit merge/rebase overlap; jj stores first-class conflicts | `jj resolve` (or edit files), then verify with `jj diff` |
| “Conflict markers keep reappearing” | Partial/unresolved conflict state persisted | `jj status` for remaining conflicts; finish resolution or `jj restore --changes-in <rev>` selectively |
| “Rebase created weird parent edges” | Complex topology operations left redundant edges | `jj simplify-parents -r <revset>` |
| “Commits should be independent but are still stacked” | Topology still encodes ancestry | `jj parallelize <revset>` then verify `jj log -n 30` |
| “I reordered commits incorrectly” | Wrong `rebase -A/-B` targets | `jj undo`, then retry with explicit commit IDs and small steps |
| “Absorb moved things in unexpected way” | Line-based destination inference picked different ancestor | Inspect with `jj op show -p`; undo and use `jj squash --from --into` manually |
| “Restore changed too much” | Default restore scope (all paths/changes-in) was broader than intended | `jj undo`; rerun with explicit paths and/or `-i` |
| “Fix/formatter changed many commits” | `jj fix` applies across selected revs and descendants | Review via `jj op show -p`; undo and rerun with narrower `-s`/paths |
| “Working copy suddenly includes/excludes many files” | Sparse patterns changed | `jj sparse list`; fix with `jj sparse set ...` or `jj sparse reset` |
| “New files keep being auto-tracked unexpectedly” | `snapshot.auto-track` + ignore patterns | `jj file untrack <path>`; adjust ignore rules and/or `snapshot.auto-track` config |
| “Immutable commit rewrite blocked” | Target revision in immutable set | Stop and confirm intent; only then consider `--ignore-immutable` |

## Triage sequence (when unsure)

```bash
jj status
jj log -n 20
jj op log -n 20
```

If still unclear, inspect historical views non-destructively:

```bash
jj --at-op=<op-id> --ignore-working-copy log -n 30
```

Then choose one of:

- `jj undo`
- `jj op restore <op-id>`
- `jj op revert <op-id>`
