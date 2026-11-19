# AGENTS.md

Guidance for coding agents working in this repository.

## Repository and deployment

- This is a mise-managed Unix dotfiles checkout; confirm root `mise.toml` and `home/` before working.
- Literal paths under `home/` map to `$HOME`. Root `mise.toml` owns deployment exceptions and permissions.
- `./install.sh` is the local deployment/update entrypoint; `./install.sh --dry-run` previews it. Preview may install mise or record trust, but must not deploy targets or prompt-save identity.
- Live-home deployment requires explicit user authorization. First cutover needs separate backups of conflicting chezmoi regular files; matching contents do not make them safe to replace. Never implicitly force: force makes no durable backup.
- Fresh deployment uses bootstrap `--only files,dotfiles --prune-dotfiles`. Never replace the user's global mise config, install unrelated tools, or change the login shell.
- Remote bootstrap uses `mise bootstrap --from <repository-url> --from-dir <persistent-checkout> --only files,dotfiles --prune-dotfiles`; keep the checkout available for symlinks. Add `--prompt-vars` only deliberately.

## Source ownership and inspection

- Most deployed leaves are symlinks: editing them already edits source. Do not capture them as if they were independent copies.
- Pi/omp preferences, Neovim's lockfile, and Fish's `fish_plugins` are copies. Inspect intentional destination changes before `mise -C "$repo" dot add --group home <target>`. Never capture whole runtime trees.
- Git/JJ identity targets are rendered templates; edit their `.tera` sources instead of capturing rendered output.
- Copy/template apply overwrites target edits. Preserve those edits before authorized deployment.
- For “what changed?”, report both scoped `mise -C "$repo" dot status <target>` / `dot diff <target>` and source VCS inspection. Native status alone cannot show edits made through source-backed links.
- Prefer Jujutsu: `jj status`, `jj diff`, `jj log -n 12`, `jj op log -n 8`. Use scoped Git status/diff when explicitly requested. Keep changes atomic; never overwrite unrelated user changes.
- Identity uses native vars: `mise -C "$repo" vars git_name='Your Name' git_email='you@example.invalid'`. Defaults work unattended; local mise override files remain untracked.

## Literal mappings and privacy

- `home/.config/nvim/init.lua` -> `~/.config/nvim/init.lua` (symlink).
- `home/.config/fish/conf.d/mise-activate.fish` -> the same home-relative target (symlink).
- `home/.pi/agent/settings.json` -> `~/.pi/agent/settings.json` (copy, `0600`).
- `home/.omp/agent/config.yml` -> `~/.omp/agent/config.yml` (copy, `0600`).
- `home/.gitconfig.tera` -> `~/.gitconfig`; `home/.config/jj/config.toml.tera` -> `~/.config/jj/config.toml` (templates).
- `.pi`, `.pi/agent`, and `.omp/agent` must remain real `0700` directories. Do not model privacy with filename prefixes.
- Pi/omp `skills` and `AGENTS.md` links contain literal `../../.config/agents/skills` and `../../.config/agents/AGENTS.md`; they resolve within the live home and may dangle. Preserve shared instruction sources; do not invent placeholders or replace regular-file conflicts.
- Keep `home/.config/nvim/.neoconf.json` inactive. Managed-only pruning preserves unrelated target files.
- Never commit `auth.json`, sessions, package caches, tokens, credentials, or other runtime state from Pi/omp or other applications.

## Managed applications

- `home/.config/nvim/`: Neovim.
- `home/.config/fish/`: Fish/Tide/Fisher; Fish is the only managed interactive shell. Keep activation interactive-only and Fisher installation opt-in.
- `home/.config/tmux/`: tmux.
- `home/.config/agents/`, `home/.pi/agent/`, `home/.omp/agent/`: shared skills/instructions and agent preferences.
- Git/JJ configuration and other literal files under `home/`.
- Windows, WSL-specific wrappers, WezTerm, Zsh, and fsh are retired. Do not redeploy them or remove existing live-home legacy files.

## tmux reloads

- Reload with `tmux source-file ~/.config/tmux/tmux.conf` only when authorized.
- Never use `tmux kill-server` unless explicitly requested; explain full-restart session loss first.

## CI and PR expectations

- CI uses `bash tests/bootstrap.sh` in disposable Linux and native macOS fixtures, never the operator's home.
- Keep unattended installation supported. No application/plugin startup is needed for deployment validation.
- Create feature branches from `master`; keep changes focused and small. Use `gh pr create` when requested; repair quoting with `gh pr edit --body-file <file>` if needed.
- Before finishing, ensure no secrets were introduced, mappings/permissions match `mise.toml`, and report actual scoped checks and notable behavior changes. Do not claim a live cutover or macOS proof from Linux-only verification.
