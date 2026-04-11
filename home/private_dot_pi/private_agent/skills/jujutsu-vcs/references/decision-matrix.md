# Quick Command Decision Matrix

Use this to choose the first `jj` command for a task.

| Task | Start with | Then usually | Safety check |
|---|---|---|---|
| See current state | `jj status` | `jj log -n 15` | `jj op log -n 5` |
| Undo last mistake | `jj undo` | `jj redo` (if needed) | `jj log -n 15` |
| Recover older known-good state | `jj op log` | `jj op restore <op-id>` | `jj status` |
| Revert one bad operation | `jj op revert <op-id>` | `jj op show <new-op>` | `jj log -n 15` |
| Split mixed commit into atomic commits | `jj split -r <rev>` | `jj describe -r <rev> -m ...` | `jj show <rev>` |
| Move fixups into older commits automatically | `jj absorb` | `jj absorb <path>` (scoped) | `jj op show -p` |
| Move changes manually between commits | `jj squash --from <src> --into <dst>` | `-i` for partial | `jj show <dst>` |
| Restore file(s) to previous content | `jj restore <paths>` | `jj restore --from <rev> --into <rev>` | `jj diff` |
| Create inverse commit(s) | `jj revert -r <rev> -o <dest>` | adjust with `-A/-B` | `jj show @` |
| Move stack to new base | `jj rebase -b @ -o <new-base>` | resolve conflicts if any | `jj log -n 30` |
| Move one commit only | `jj rebase -r <rev> -o <parent>` | reorder via `-A/-B` | `jj log -n 30` |
| Reorder many commits interactively | `jj arrange <revset>` | cleanup with `jj simplify-parents` | `jj log -n 30` |
| Declare commits independent (siblings) | `jj parallelize <revset>` | verify topology | `jj log -n 30` |
| Investigate rewrite history of a change | `jj evolog -r <rev>` | `jj interdiff --from A --to B` | — |
| Inspect old repo state without mutating | `jj --at-op=<id> --ignore-working-copy log` | `... status` | — |
| Sync with remote | `jj git fetch --remote <r>` | `jj git push --remote <r>` | `jj bookmark list` |
| Push specific work only | `jj git push --bookmark <name>` | or `--change <rev>` | `--dry-run` |
| Resolve bookmark tracking issues | `jj bookmark list --all` | `jj bookmark track/untrack/move` | `jj status` |
| Handle stale workspace | `jj workspace update-stale` | continue work | `jj status` |
| Create extra workspace | `jj workspace add <path> --name <n>` | `jj workspace list` | `jj workspace root --name <n>` |
| Reduce checkout scope | `jj sparse set --clear --add <path>` | `jj sparse list` | `jj status` |
| Run formatters across mutable stack | `jj fix` | scope via `-s`/paths | `jj op show -p` |
| Find first bad revision automatically | `jj bisect run --range A..B -- <cmd>` | `--find-good` if needed | note exit codes |
| Resolve conflicts | `jj resolve` | or edit + `jj diff` | `jj status` |
| Resolve divergent changes | `jj log` (find `/0`,`/1`) | `abandon` / `metaedit --update-change-id` / `squash` | `jj log -n 20` |

## Default pre/post rewrite checklist

```bash
jj status
jj log -n 20
jj op log -n 5
# ... mutate history ...
jj status
jj log -n 20
jj op log -n 5
```
