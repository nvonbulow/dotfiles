# Revsets, Filesets, Templates, and Inspection

These are force multipliers for automation and safe scripting.

## Revsets (`jj help -k revsets`)

- Powerful commit selection language.
- `@` is working-copy commit; `<name>@<remote>` for remote-tracking bookmark.
- Hidden/divergent behavior matters; ambiguous change IDs may need `/0`, `/1` offsets.
- Prefer explicit revsets in scripts (e.g., `commit_id(...)`) to avoid symbol-priority surprises.

Examples:

```bash
jj log -r 'mutable() & ancestors(@)'
jj rebase -s 'roots(trunk()..@)' -o trunk()
```

## Filesets (`jj help -k filesets`)

- File selection language used in many commands (`diff`, `split`, `restore`, etc.).
- Supports `glob:`, `root:`, `file:`, unions/intersections/subtractions.

Examples:

```bash
jj diff 'glob:"src/**/*.rs" ~ glob:"**/*_generated.rs"'
jj split '~glob:"docs/**"'
```

## Templates (`jj help -k templates`)

- Customize output in `jj log`, `jj op log`, `jj file annotate`, etc.
- Useful for machine-friendly output and better human summaries.

Examples:

```bash
jj log -T 'commit_id.short() ++ " " ++ description.first_line() ++ "\n"'
jj op log -T 'id.short() ++ " " ++ description ++ "\n"'
```

## Inspection commands worth using often

```bash
jj show <rev>
jj diff -r <rev>
jj interdiff --from <a> --to <b>
jj evolog -r <rev>
jj op show <op-id>
```

- `interdiff` compares patch-vs-patch between revisions.
- `evolog` tracks how a change evolved across rewrites.
