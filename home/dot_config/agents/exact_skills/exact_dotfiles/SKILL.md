---
name: dotfiles
description: Use chezmoi + Jujutsu to sync live dotfile edits (including outside the repo) back into the managed source tree as atomic changesets.
---

# Dotfiles Skill

Use this skill when edits happen in materialized files (for example `~/.config/nvim`) and must be synced back to the chezmoi source repo.

## Core rules

1. Treat the chezmoi source tree as the source of truth for version control.
2. Capture destination-file edits with `chezmoi add`, not copy/paste.
3. Use `jj` for all VCS operations unless explicitly asked to use Git.
4. Never run `chezmoi apply` just to sync destination -> source.
5. Before `chezmoi add`, inspect the source repo for existing modifiers (`private_`, `exact_`, etc.) and choose matching `chezmoi add` flags.

## Quick discovery

```bash
chezmoi source-path
chezmoi status
```

- `chezmoi source-path` gives the repo root to run `jj` commands against.
- `chezmoi status` shows tracked targets that differ.

## Primary workflow: destination edits -> repo changes

Example: you edited `~/.config/nvim` directly.

```bash
# 1) Find source repo and inspect existing naming/modifier patterns first
SRC=$(chezmoi source-path)
cd "$SRC"
jj status
jj log -n 12
jj op log -n 8

# 2) Inspect existing source entries for the same target path
# Example target: ~/.config/nvim
# Look for home/dot_config/nvim, home/private_dot_config/nvim, home/exact_dot_config/nvim, etc.

# 3) Capture destination state into source using matching semantics:
# - if target is directory and should be exact_ managed:
chezmoi add --exact ~/.config/nvim
# - if source already uses private_ (or another modifier), mirror that modifier;
#   confirm the exact flag in `chezmoi add --help` before running add.
# - otherwise:
chezmoi add ~/.config/nvim

# 4) Optional scoped verification from chezmoi side
chezmoi status ~/.config/nvim
chezmoi diff ~/.config/nvim

# 5) Review captured changes in source repo
jj diff

# 6) Commit atomically
jj describe -m "sync: update neovim config"
jj commit -m "sync: update neovim config"

# 7) Post-mutation safety snapshot
jj status
jj log -n 12
jj op log -n 8
```

## Mapping reminders

- `~/.config/nvim/init.lua` -> `home/dot_config/nvim/init.lua`
- `~/.zshrc` -> `home/dot_zshrc`
- Private targets should use `private_` naming in source.

## When asked “what changed?”

Report both views:

```bash
# In source repo
jj status
jj diff

# In chezmoi view (target-scoped when possible)
chezmoi status <target>
chezmoi diff <target>
```

## Safety guardrails

- Do not commit secrets from runtime dirs (`~/.pi/agent/auth.json`, sessions, caches).
- Prefer scoped `chezmoi status/diff` for large trees.
- If repo state is confusing after a rewrite, recover with:

```bash
jj undo
# or
jj op restore <op-id>
```
