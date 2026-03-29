# AGENTS.md

Guidance for coding agents working in this repository.

## Repository purpose

- This is a **chezmoi-managed dotfiles** repo.
- Source files live under `home/` and are materialized into `$HOME` by chezmoi.
- Installer: `./install.sh` (runs `chezmoi init --apply --source=<repo>`).

## Important conventions

- Prefer **chezmoi-native workflows** over editing destination files directly.
- When capturing existing machine state, use:
  - `chezmoi add <target>` (destination -> source)
- Avoid using `chezmoi apply` unless explicitly asked to push source -> destination.
- For validation, scope commands when possible:
  - `chezmoi status <target>`
  - `chezmoi diff <target>`
  - `chezmoi apply --dry-run --verbose <target>`
- When asked “what changed” for any dotfile/target, verify and report from **both**:
  - git: `git status --short <path>` and/or `git diff -- <path>`
  - chezmoi: `chezmoi status <target>` and `chezmoi diff <target>`

## tmux config reloads (non-destructive)

- Apply tmux config updates with:
  - `tmux source-file ~/.config/tmux/tmux.conf`
- Do **not** use `tmux kill-server` unless explicitly requested by the user.
- If a full tmux restart is required, explain impact first (all sessions terminate) and get confirmation.

## Chezmoi path mapping reminders

- `home/dot_foo` -> `~/.foo`
- `home/private_dot_foo` -> `~/.foo` with private permissions (e.g. `0700` dir semantics)
- `home/executable_dot_foo` -> `~/.foo` executable
- `home/*/*.tmpl` are templates rendered by chezmoi

## Pi config in this repo

- Pi config is currently managed at:
  - `home/private_dot_pi/private_agent/settings.json` -> `~/.pi/agent/settings.json`
- Keep `.pi` and `.pi/agent` private-mode semantics.
- Do **not** commit runtime/secrets from `~/.pi/agent` (e.g. `auth.json`, sessions, package cache dirs).

## Existing repo structure (high-level)

- `home/dot_config/nvim/` - Neovim config
- `home/dot_config/zsh/` - Zsh config
- `home/dot_config/tmux/` - tmux config
- `home/dot_config/wezterm/` - WezTerm config + terminfo script
- `home/dot_local/bin/` - local helper executables

## CI expectations

- CI runs `./install.sh` and checks `chezmoi data`.
- Keep changes compatible with non-interactive setup (e.g., Codespaces/CI).

## PR workflow expectations

- Create feature branch from `master`.
- Keep commits focused and small.
- Use `gh pr create` for PRs when available.
- If PR body/title is malformed due to shell quoting, fix with:
  - `gh pr edit --body-file <file>`

## Safety checklist before finishing

1. `chezmoi status` (or scoped status) is as expected.
2. No secrets/tokens added to source.
3. Paths and permissions align with chezmoi conventions (`dot_`, `private_`, `executable_`).
4. Document notable behavior changes in PR description.
