# Specialized and Advanced Tools

## `jj fix` (batch formatters / deterministic transforms)

- Runs configured tools over changed files in selected revisions and descendants.
- Designed for formatters; deduplicates identical file-content invocations.

```bash
jj fix
jj fix -s 'reachable(@, mutable())'
jj fix --include-unchanged-files
```

## `jj bisect run` (automated first-bad/first-good)

```bash
jj bisect run --range v1.0..main -- <command> [args...]
jj bisect run --range v1.0..main --find-good -- <command>
```

- Exit code contract: `0=good`, `125=skip`, `127=abort`, other non-zero=bad.
- Target commit ID exposed as `$JJ_BISECT_TARGET`.

## Conflict tooling

```bash
jj resolve
jj restore --changes-in <rev>
```

Docs emphasize first-class conflicts: conflicted commits can exist and be rebased/merged before final resolution.

## Signatures

```bash
jj sign -r <revset>
jj unsign -r <revset>
```

Requires signing backend config.

## File-level utilities

```bash
jj file annotate path/to/file
jj file search --pattern '*TODO*'
jj file chmod +x 'glob:"scripts/**"'
```

## Gerrit and tags

```bash
jj gerrit upload --dry-run
jj tag list
jj tag set v1.2.3 -r <rev>
```

## Low-level utilities

```bash
jj util snapshot
jj util gc
jj util completion bash
jj util markdown-help
```

Use sparingly; useful for automation and environment bootstrapping.
