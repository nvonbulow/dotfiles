---
name: dotfiles
description: Safely manage this mise dotfiles checkout using scoped inspection, explicit copy capture, source template edits, and atomic Jujutsu changes without deploying to the live home or capturing secrets.
---

# Dotfiles Skill

Use for dotfiles edits, destination-to-source capture, and focused PR preparation.

## Repository guard

Locate the intended checkout from context (or `git rev-parse --show-toplevel` in a Git checkout). Confirm its root contains `mise.toml` and `home/`; a source copy without Git metadata is valid for deployment. If the repository cannot be located, stop and request its path. Do not discover it by reading unrelated home configuration.

Set `$repo` to that checkout. Literal files under `home/` are the source of truth; no chezmoi filename modifiers remain.

## Inspect before changing

```sh
mise -C "$repo" dot status <target>
mise -C "$repo" dot diff <target>
cd "$repo"
jj status
jj diff
jj log -n 12
jj op log -n 8
```

Use Jujutsu for VCS unless explicitly asked for Git. For “what changed?”, report both native deployment state and source VCS changes: editing a deployed symlink changes source immediately and may leave native status already applied. Scope commands and changes to requested paths; preserve unrelated work.

## Choose the correct edit direction

- **Linked leaves:** edit the source, or recognize that an edit through the destination symlink already edited it. Do not recapture directories.
- **Copies:** Pi/omp preferences, Neovim `lazy-lock.json`, and Fish `fish_plugins` are independent regular files. Inspect intentional target contents and source differences, excluding runtime/secrets, before explicit capture:

  ```sh
  mise -C "$repo" dot add --group home <target>
  ```

- **Templates:** edit `home/.gitconfig.tera` or `home/.config/jj/config.toml.tera`; never capture rendered targets. Identity uses native vars, e.g. `mise -C "$repo" vars git_name='Your Name' git_email='you@example.invalid'`. Defaults work unattended; interactive installation prompts. Keep personal `mise.local.toml` / `mise.*.local.toml` overrides untracked.

Copy/template apply overwrites destination edits. Capture intentional copy edits before an authorized apply; do not introduce a merge or create-if-missing policy.

## Mappings and deployment invariants

- `~/.config/nvim/init.lua` -> `home/.config/nvim/init.lua` (symlink).
- `~/.config/fish/conf.d/mise-activate.fish` -> `home/.config/fish/conf.d/mise-activate.fish` (symlink).
- `~/.pi/agent/settings.json` -> `home/.pi/agent/settings.json` (copy, `0600`).
- `~/.omp/agent/config.yml` -> `home/.omp/agent/config.yml` (copy, `0600`).
- `.pi`, `.pi/agent`, and `.omp/agent` are real private `0700` directories, declared in `mise.toml`; do not use naming prefixes or whole-directory links.
- Pi/omp agent `skills` and `AGENTS.md` links contain literally `../../.config/agents/skills` and `../../.config/agents/AGENTS.md`. They resolve within the destination home; dangling referents are valid. Reject regular-file/directory conflicts and preserve the existing shared instructions rather than creating placeholders.
- Keep `.config/nvim/.neoconf.json` inactive; do not deploy raw `.tera` or retired control files.
- Preserve target-only files. Pruning removes only recorded obsolete managed files, not unmanaged leaves.
- Fish is the sole managed interactive shell. Preserve interactive-only mise activation and Fisher's opt-in installation. Windows, WSL-specific wrappers, WezTerm, Zsh, and fsh are retired; do not recreate them or delete live legacy state.

## Safety and deployment

Never commit credentials, tokens, auth files, sessions, caches, Pi/omp `git/` or `npm/` runtime directories, or machine-specific state. Capture only inspected individual managed targets, never broad home/runtime trees.

`./install.sh --dry-run` previews bootstrap; it may install mise and record trust but must not deploy targets or save prompted identity. Native status/diff provides rendered template inspection separately.

**Live-home deployment requires explicit authorization in this conversation.** `./install.sh` applies source to home; fresh deployment requires both `files,dotfiles` phases. Before first live cutover, separately back up and deliberately move aside conflicting chezmoi regular files, even when contents match. Never add implicit `--force-dotfiles`: force makes no durable backup. No live cutover is part of this migration.

Remote deployment uses `mise bootstrap --from <repository-url> --from-dir <persistent-checkout> --only files,dotfiles --prune-dotfiles`, optionally `--prompt-vars`. Keep the checkout for symlink referents. Do not adopt history, replace global mise configuration, install unrelated tools, or change the login shell.

Destructive VCS actions, shared-history rewrites, and out-of-scope deletions require explicit authorization. If recovery is necessary, inspect `jj op log` and explain impact before `jj undo` or `jj op restore <op-id>`; do not overwrite unrelated user work.

## Finish atomically

1. Identify requested targets and edit direction.
2. Inspect scoped native state and source VCS state.
3. Edit linked/template sources or explicitly capture inspected copies.
4. When authorized, run only the requested checks. Deployment tests use disposable fixtures, not the live home.
5. Review `jj diff`; create a focused change with `jj describe -m "..."` and `jj commit -m "..."` when requested. Inspect status/log/op-log after VCS mutations.
6. Report actual validation, exclusions, and deployment limits. PRs should include Summary, Validation, and Safety; never claim checks not run.

Invocation arguments to `/skill:dotfiles` constrain this workflow.
