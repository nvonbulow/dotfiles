---
name: dotfiles
description: Safely manage this chezmoi-based dotfiles repo. Use when syncing destination state into source with chezmoi add, validating scoped diffs, handling permissions/private naming, and preparing focused commits/PRs without leaking secrets.
---

# Dotfiles Skill (v2)

Use this skill for any request involving dotfiles changes, chezmoi synchronization, or PR prep in this repository.

## Objectives

- Keep changes reproducible and declarative through chezmoi source.
- Prefer destination -> source sync (`chezmoi add`) unless explicitly told otherwise.
- Minimize blast radius by scoping checks and edits to requested targets.
- Prevent secrets/runtime artifacts from entering git history.

## Repository guard (required first step)

Before doing anything else, verify this is the dotfiles repository context.

1. Determine repo root:
   - `git rev-parse --show-toplevel`
2. Confirm the root contains `.chezmoiroot`.
3. If either check fails:
   - Stop.
   - Tell the user this is a repo-local skill for the dotfiles repository.
   - Ask them to `cd` to the dotfiles repo (or provide the correct path) and retry.

## Repo assumptions

- This repo is a chezmoi source directory.
- Installer is `./install.sh` (runs `chezmoi init --apply --source=<repo>`).
- Pi config currently maps from:
  - `home/private_dot_pi/private_agent/settings.json`
  - to `~/.pi/agent/settings.json`
- `private_` naming is used where destination permissions must remain private (e.g. `.pi` paths).

## Safety policy

### Safe-by-default command policy

Prefer these commands first:

```bash
chezmoi status <target>
chezmoi diff <target>
chezmoi add <target>
chezmoi source-path <target>
chezmoi apply --dry-run --verbose <target>
```

Use targeted git operations:

```bash
git status --short
git add <specific paths>
git commit -m "..."
```

When the user asks what changed for a dotfile/target, always check and report both views:

```bash
git status --short <path>
git diff -- <path>
chezmoi status <target>
chezmoi diff <target>
```

### Commands requiring explicit user confirmation

Do **not** run the following unless user explicitly requests it in this conversation:

- `chezmoi apply` (without `--dry-run`)
- broad destructive git actions (`git reset --hard`, `git clean -fdx`, force push to unrelated branches)
- history rewrites affecting shared branches
- deletion/moves beyond requested scope

If such a command seems necessary, ask for confirmation and state impact first.

## Secrets and runtime exclusions

Never commit or template runtime/secrets from home state, including (not exhaustive):

- `~/.pi/agent/auth.json`
- `~/.pi/agent/sessions/`
- `~/.pi/agent/git/`, `~/.pi/agent/npm/`
- transient caches, tokens, local machine state

If encountered, explicitly exclude and explain why.

## Chezmoi naming and permission rules

When adding new managed entries, choose source path prefixes correctly:

- `dot_foo` -> destination `.foo`
- `private_dot_foo` -> destination `.foo` with private perms semantics
- `executable_dot_foo` -> destination executable `.foo`
- `.tmpl` for templated files

If destination mode drift appears for private dirs, prefer modeling with `private_` pathing rather than chmod hacks.

## Standard operating procedure

1. **Clarify scope**
   - Identify exact target files/directories and intended direction of sync.
2. **Inspect current state**
   - Run scoped `chezmoi status`/`diff` first.
   - For “what changed?” questions, also run scoped `git status`/`diff` on corresponding source paths.
3. **Sync correctly**
   - Use `chezmoi add <target>` for destination -> source capture.
   - Use source edits only when user wants source-first changes.
4. **Validate**
   - Re-run scoped status/diff; optionally dry-run apply for affected target.
5. **Commit minimally**
   - Stage only relevant files; concise commit message.
6. **PR hygiene**
   - Include summary, safety notes, and any intentional exclusions.

## PR body template

Use this structure when asked to open/update a PR:

```md
## Summary
- <change 1>
- <change 2>

## Validation
- `chezmoi status <target>`
- `chezmoi diff <target>`
- `chezmoi apply --dry-run --verbose <target>`

## Safety
- confirmed no secrets/runtime artifacts were committed
- scoped changes only to requested targets
```

## Quick checklists

### Before commit

- [ ] Changes are in chezmoi source paths (not only destination state)
- [ ] `chezmoi status/diff` scoped output matches intent
- [ ] No secrets/runtime files staged
- [ ] Naming prefixes (`dot_`, `private_`, `executable_`) are correct

### Before PR complete

- [ ] Branch is correct and up to date
- [ ] Commit scope is minimal
- [ ] PR description explains validation and safety constraints

## Invocation notes

If invoked with `/skill:dotfiles <args>`, treat `<args>` as constraints and apply this policy/workflow while solving the user task.
