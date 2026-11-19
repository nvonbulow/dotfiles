---
name: dotfiles
description: Use mise and Jujutsu to manage linked dotfiles, capture inspected copy edits, and maintain source templates as atomic changes without exposing runtime state or implicitly deploying.
---

# Dotfiles Skill

Use when working on this repository or syncing edits from managed home targets.

## Locate and inspect

Locate the intended persistent checkout from task context (or `git rev-parse --show-toplevel` inside it). Confirm root `mise.toml` and `home/`; deployment also supports source copies without Git metadata. If it cannot be located, request the checkout path rather than inspecting unrelated home configuration.

Set `$repo` to the checkout. Prefer Jujutsu for all VCS operations unless Git is explicitly requested:

```sh
cd "$repo"
jj status
jj diff
jj log -n 12
jj op log -n 8
mise -C "$repo" dot status <target>
mise -C "$repo" dot diff <target>
```

For “what changed?”, report both source VCS and scoped native deployment views. Native status alone misses edits already made through source-backed symlinks.

## Capture according to ownership

1. **Symlink leaves:** editing the home target already edits the checkout source. Inspect that source diff; do not copy or recapture a directory.
2. **Copies:** Pi/omp preferences, Neovim's `lazy-lock.json`, and Fish's `fish_plugins` are independent copies. Inspect target content and source diff first; capture only the intentional managed target:

   ```sh
   mise -C "$repo" dot add --group home <target>
   ```

3. **Templates:** edit `.tera` source, never capture rendered Git/JJ config. Set identity through native `mise -C "$repo" vars git_name='Your Name' git_email='you@example.invalid'` or normal mise overrides. Defaults work unattended; interactive installation prompts. Keep `mise.local.toml` and `mise.*.local.toml` personal overrides untracked.

Copy/template apply overwrites destination edits; capture intentional copy edits first. Do not introduce merge or create-if-missing semantics.

## Literal mappings and invariants

- `~/.config/nvim/init.lua` -> `home/.config/nvim/init.lua` (link).
- `~/.config/fish/conf.d/mise-activate.fish` -> `home/.config/fish/conf.d/mise-activate.fish` (link).
- `~/.pi/agent/settings.json` -> `home/.pi/agent/settings.json` (copy, `0600`).
- `~/.omp/agent/config.yml` -> `home/.omp/agent/config.yml` (copy, `0600`).
- `~/.gitconfig` -> `home/.gitconfig.tera`; `~/.config/jj/config.toml` -> `home/.config/jj/config.toml.tera` (rendered templates).
- `.pi`, `.pi/agent`, and `.omp/agent` remain real `0700` directories declared in `mise.toml`. No filename permission modifiers or whole-agent-directory links.
- Pi/omp agent `skills` and `AGENTS.md` links contain literal `../../.config/agents/skills` and `../../.config/agents/AGENTS.md`. They resolve in the destination home and may dangle; preserve shared instruction sources, do not invent placeholders, and reject non-symlink conflicts.
- Keep `.config/nvim/.neoconf.json` inactive and raw templates/control files undeployed. Managed-only pruning preserves unrelated target files.
- Fish is the only managed interactive shell. Preserve interactive-only mise activation and Fisher's opt-in plugin installation. Do not restore Windows, WSL wrappers, WezTerm, Zsh, or fsh; do not delete existing live legacy files.

## Deployment safety

Never capture runtime/secrets: Pi/omp auth files, sessions, caches, `git/`, `npm/`, credentials, tokens, or machine state. Inspect individual targets, not whole runtime directories.

Use `./install.sh --dry-run` for preview; it may install mise and record trust but must not deploy targets or save prompted identity. Inspect templates separately with native status/diff.

Do not run `./install.sh` or other live-home apply without explicit authorization. Fresh bootstrap requires both `files,dotfiles` phases. First live cutover requires separate durable backups and deliberate handling of conflicting chezmoi regular files, even if contents match. Never implicitly force: `--force-dotfiles` makes no durable backup. This migration does not authorize live cutover.

Remote bootstrap: `mise bootstrap --from <repository-url> --from-dir <persistent-checkout> --only files,dotfiles --prune-dotfiles`; add `--prompt-vars` only deliberately. Keep the source checkout for deployed links. Do not adopt history, replace global mise config, install unrelated tools, or change the login shell.

## Atomic Jujutsu workflow

1. Identify target scope and edit direction; inspect native/source state.
2. Edit linked/template source or capture an inspected copy; preserve unrelated work.
3. Review scoped native status/diff and `jj diff`; run only authorized checks in disposable fixtures.
4. When requested, record a focused change with `jj describe -m "sync: update configuration"` and `jj commit -m "sync: update configuration"`.
5. Inspect `jj status`, `jj log -n 12`, and `jj op log -n 8` after VCS mutations; report actual validation and safety exclusions.

If recovery is needed, inspect the operation log first. `jj undo` or `jj op restore <op-id>` can recover operations, but explain impact and obtain authorization before destructive changes or shared-history rewrites. Never use recovery to overwrite unrelated user changes.
