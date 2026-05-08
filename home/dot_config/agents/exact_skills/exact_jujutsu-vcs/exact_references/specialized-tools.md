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

### Gerrit relation-chain workflow

For Gerrit repositories, consider a commit-message template that derives `Change-Id` from jj's `change_id` so editing a change preserves review identity. Repository config example:

```toml
[template-aliases]
'gerrit_change_id(change_id)' = '"Id0000000" ++ change_id.normal_hex()'

[templates]
draft_commit_description = '''
separate("\n",
  description.remove_suffix("\n"),
  if(!description.contains(change_id.normal_hex()),
    "\nChange-Id: " ++ gerrit_change_id(change_id)
  ),
  "\n",
  surround("JJ: Changes:\n", "", indent("JJ: \t", diff.summary()))
)
'''
```

Recommended review-fix loop:

```bash
# work at the relation-chain head
jj squash --into <reviewed-rev> -i
jj log -n 30
```

After Gerrit merges a relation chain and `jj git fetch` imports the merged commits, clean the obsolete local chain:

```bash
jj abandon -r <merged-local-root>::
```

## Low-level utilities

```bash
jj util snapshot
jj util gc
jj util completion bash
jj util markdown-help
```

Use sparingly; useful for automation and environment bootstrapping.
