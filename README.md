# dotfiles

Unix dotfiles managed by [mise](https://mise.jdx.dev/) (supported baseline: **2026.11.8**), with this checkout as the source of truth. Supports macOS and ordinary Linux; Fish is the only managed interactive shell. No Windows, WSL-specific wrappers, WezTerm, or Zsh deployment remains.

## Install and update

From a persistent checkout:

```sh
./install.sh --dry-run
./install.sh
```

The installer locates mise or installs the pinned baseline, rejects older versions, trusts only this repository's `mise.toml`, and runs bootstrap's `files,dotfiles` phases with managed-only pruning. It does not install unrelated global tools or change your login shell. Noninteractive runs use default identity without prompting; interactive real runs prompt for identity. Preview may install mise and record trust, but does not deploy targets or save prompted identity.

**Do not perform a live-home cutover without explicit authorization.** First separately back up conflicting regular files left by chezmoi and move them aside deliberately. Matching contents still conflict with symlink deployment. The installer never adds `--force-dotfiles`; force is destructive and makes no durable backup. Copy/template apply overwrites destination edits, so inspect and capture intentional changes first.

For remote bootstrap, supply your repository URL and a persistent checkout location:

```sh
mise bootstrap --from <repository-url> --from-dir <persistent-checkout> --only files,dotfiles --prune-dotfiles
```

Add `--prompt-vars` only when desired. Keep that checkout available: deployed symlinks depend on it. Do not use history adoption or replace the user's global mise configuration.

## Deployment model and migration notes

`home/` now uses literal destination-relative names, not chezmoi modifiers. `mise.toml` declares deployment:

- Most leaves are symlinks; application directories remain real so runtime additions stay outside the checkout.
- Git and JJ identities are rendered from `.gitconfig.tera` and `.config/jj/config.toml.tera`. Edit templates in source; never capture rendered targets. Git's `secure-transport` backend is macOS-only.
- Pi/omp preferences, Neovim's `lazy-lock.json`, and Fish's `fish_plugins` are authoritative source-to-target copies. Preferences are `0600`; `.pi`, `.pi/agent`, and `.omp/agent` are real `0700` directories.
- Four agent links point literally to `../../.config/agents/skills` or `../../.config/agents/AGENTS.md` from the Pi/omp agent directories. They resolve within the destination home, permit missing referents, and reject non-symlink conflicts. Do not replace the shared instructions with a placeholder.
- `.config/nvim/.neoconf.json` stays inactive. Templates and retired chezmoi control files are not deployed as literal files. Runtime files, credentials, sessions, caches, and local overrides are not capture inputs.
- Managed-only pruning removes recorded obsolete managed leaves, not unmanaged files. Retired integrations already present in a home are left alone.
- Fish's `conf.d/mise-activate.fish` activates mise only interactively, without changing Fisher's opt-in plugin-install workflow.

Identity defaults are `nvonbulow` / `nick@nvonbulow.com`. Set native overrides from the checkout:

```sh
mise -C "$repo" vars git_name='Your Name' git_email='you@example.invalid'
```

Normal mise overrides also work; `mise.local.toml` and `mise.*.local.toml` stay untracked. No host chezmoi identity is imported.

## Editing and inspection

Editing a deployed symlink edits its source immediately. For a copied target, inspect its contents and then explicitly capture only that target:

```sh
mise -C "$repo" dot add --group home <target>
```

Never capture secrets or whole runtime directories. Before an authorized deployment, inspect scoped native state and source VCS changes:

```sh
mise -C "$repo" dot status <target>
mise -C "$repo" dot diff <target>
# In the checkout:
jj status
jj diff
```

Use Git status/diff instead when explicitly requested. Source VCS shows linked-target edits that native deployment status may already consider applied. Fresh deployment needs both bootstrap phases, not just `mise dot apply`.

CI runs `bash tests/bootstrap.sh` in isolated Linux and native macOS fixtures, covering deployment, conflicts, privacy, pruning, identity, and real Fish activation without applying to a user's home.

Migration verification: all ten smoke scenarios passed in Linux Docker/OrbStack, including real Fish activation. An authorized macOS live cutover also passed deployment status, link/copy shape, private permission, and identity checks. The full native macOS fixture suite remains a CI check.

## License

MIT