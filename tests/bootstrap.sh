#!/usr/bin/env bash
set -euo pipefail

# Re-exec without inherited mise/Git selection, activation state, credentials, or
# user PATH entries. Nothing below reads the invoking user's home configuration.
script_dir=$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
if [[ ${BOOTSTRAP_SMOKE_ISOLATED:-} != 1 ]]; then
    exec /usr/bin/env -i \
        PATH=/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/usr/local/bin \
        BOOTSTRAP_SMOKE_ISOLATED=1 \
        /bin/bash "$script_dir/bootstrap.sh"
fi
source_repo=$(CDPATH= cd -- "$script_dir/.." && pwd -P)
work=$(mktemp -d '/tmp/dotfiles smoke.XXXXXX')
trap 'rm -rf -- "$work"' EXIT
trap 'printf "FAIL: line %s: %s\n" "$LINENO" "$BASH_COMMAND" >&2' ERR

fail() { printf 'FAIL: %s\n' "$*" >&2; exit 1; }
pass() { printf 'ok %s\n' "$*"; }
assert_eq() { [[ $1 == "$2" ]] || fail "${3:-value}: expected [$2], got [$1]"; }
assert_absent() { [[ ! -e $1 && ! -L $1 ]] || fail "unexpected path: $1"; }
assert_regular() { [[ -f $1 && ! -L $1 ]] || fail "not a regular copy: $1"; }
assert_contains() { grep -F -- "$2" "$1" >/dev/null || fail "$1 does not contain: $2"; }
assert_text() { assert_eq "$(cat -- "$1")" "$2" "$1"; }
assert_no_templates() {
    if grep -E '\{\{|\{%|\.git(Name|Email)|\.chezmoi' "$@"; then
        fail 'unrendered identity template'
    fi
}

case $(uname -s) in
    Linux) platform=linux ;;
    Darwin) platform=macos ;;
    *) fail 'smoke tests support only Linux and macOS' ;;
esac
fish_bin=$(command -v fish) || fail 'install Fish before running the smoke tests'
[[ $fish_bin == /* ]] || fail 'Fish must resolve to an absolute executable'
command -v git >/dev/null || fail 'install Git before running the smoke tests'
command -v curl >/dev/null || fail 'install curl before running the smoke tests'

# An allowlisted tools directory guarantees even a preinstalled host mise cannot
# bypass the installer's first pinned download. These are real Unix tools, not
# mocks; later fixtures add only the freshly downloaded mise to this PATH.
tools="$work/tools"
shared_bin="$work/bin"
mkdir -p "$tools" "$shared_bin"
for name in awk basename bash cat chmod chown cmp cp curl cut date dirname env file find \
    git grep gzip head id install ldd ln ls mkdir mktemp mv printf ps pwd readlink \
    rm rmdir sed sh shasum sha256sum sort stat tail tar tee touch tr uname wc \
    wget xz zstd; do
    resolved=$(command -v "$name" || true)
    if [[ $resolved == /* && -x $resolved ]]; then
        ln -s "$resolved" "$tools/$name"
    fi
done
export PATH="$tools"

use_fixture() {
    fixture="$work/$1"
    repo="$fixture/source checkout"
    export HOME="$fixture/home"
    export XDG_CONFIG_HOME="$HOME/.config"
    export XDG_DATA_HOME="$HOME/.local/share"
    export XDG_CACHE_HOME="$HOME/.cache"
    export XDG_STATE_HOME="$HOME/.local/state"
    export MISE_CONFIG_DIR="$XDG_CONFIG_HOME/mise"
    export MISE_DATA_DIR="$XDG_DATA_HOME/mise"
    export MISE_CACHE_DIR="$XDG_CACHE_HOME/mise"
    export MISE_STATE_DIR="$XDG_STATE_HOME/mise"
    export MISE_SYSTEM_CONFIG_DIR="$fixture/system mise"
    # Explicit files also isolate macOS builds whose default global filename was
    # resolved independently of HOME/XDG directory overrides.
    export MISE_GLOBAL_CONFIG_FILE="$MISE_CONFIG_DIR/config.toml"
    export MISE_GLOBAL_CONFIG_ROOT="$HOME"
    export MISE_SYSTEM_CONFIG_FILE="$fixture/nonexistent-system.toml"
    export MISE_CEILING_PATHS="$fixture"
    export TMPDIR="$fixture/tmp"
    export GIT_CONFIG_NOSYSTEM=1
    export GIT_CONFIG_SYSTEM=/dev/null
    export GIT_CONFIG_GLOBAL=/dev/null
    export GIT_TERMINAL_PROMPT=0
    export TERM=xterm-256color
    export NO_COLOR=1
    export PATH="$shared_bin:$tools"
    mkdir -p "$HOME" "$TMPDIR" "$MISE_CONFIG_DIR" "$MISE_DATA_DIR" \
        "$MISE_CACHE_DIR" "$MISE_STATE_DIR" "$MISE_SYSTEM_CONFIG_DIR" "$repo"
    # Exclude personal mise overrides as well as VCS metadata: defaults must not
    # accidentally depend on an operator's untracked identity configuration.
    tar -C "$source_repo" --exclude=.git --exclude=.jj \
        --exclude=mise.local.toml --exclude='mise.*.local.toml' \
        --exclude=.mise.local.toml --exclude='.mise.*.local.toml' \
        -cf - . | tar -C "$repo" -xf -
    assert_absent "$repo/.git"
    assert_absent "$repo/.jj"
    cd "$fixture"
}

run_installer() (
    cd "$repo"
    ./install.sh "$@" </dev/null
)

apply() {
    if ! run_installer >"$fixture/install.log" 2>&1; then
        cat "$fixture/install.log" >&2
        fail "installer failed in $fixture"
    fi
}

assert_applied() {
    mise -C "$repo" dot status --missing
    mise -C "$repo" bootstrap files status --missing
}

mode_of() {
    if [[ $platform == linux ]]; then stat -c %a "$1"; else stat -f %Lp "$1"; fi
}

assert_identity() {
    assert_eq "$(git config --file "$HOME/.gitconfig" --get user.name)" "$1" 'Git name'
    assert_eq "$(git config --file "$HOME/.gitconfig" --get user.email)" "$2" 'Git email'
    assert_contains "$HOME/.config/jj/config.toml" "name = $3"
    assert_contains "$HOME/.config/jj/config.toml" "email = \"$2\""
    assert_no_templates "$HOME/.gitconfig" "$HOME/.config/jj/config.toml"
}

fresh_and_local_state() (
    use_fixture fresh
    command -v mise >/dev/null && fail 'first fixture unexpectedly found mise'
    assert_absent "$HOME/.local/bin/mise"
    printf '[tools]\nnode = "24"\n' >"$MISE_CONFIG_DIR/config.toml"
    cp "$MISE_CONFIG_DIR/config.toml" "$fixture/global.expected"
    apply
    [[ -x $HOME/.local/bin/mise ]] || fail 'installer did not install mise in the fixture'
    cp "$HOME/.local/bin/mise" "$shared_bin/mise"
    chmod +x "$shared_bin/mise"
    case $(mise --version) in
        2026.11.8\ *) ;;
        *) fail 'first installation did not use mise 2026.11.8' ;;
    esac
    cmp "$fixture/global.expected" "$MISE_CONFIG_DIR/config.toml"
    assert_absent "$MISE_DATA_DIR/installs/node"
    mise -C "$repo" config ls --json >"$fixture/configs.json"
    assert_contains "$fixture/configs.json" "$MISE_CONFIG_DIR/config.toml"
    if grep -Ei 'node.*(installing|would install|downloading)|(installing|downloading).*node' "$fixture/install.log"; then
        fail 'bootstrap attempted to install the unrelated Node tool'
    fi
    assert_applied
    assert_identity nvonbulow nick@nvonbulow.com '"nvonbulow"'
    if [[ $platform == linux ]]; then
        if git config --file "$HOME/.gitconfig" --get http.sslBackend; then
            fail 'Linux inherited the macOS Git TLS backend'
        fi
    else
        assert_eq "$(git config --file "$HOME/.gitconfig" --get http.sslBackend)" secure-transport
    fi
    pass '1 fresh unattended install, default identity, unchanged global tools'

    for path in .config/nvim/init.lua .config/fish/conf.d/mise-activate.fish; do
        [[ -L $HOME/$path && $HOME/$path -ef $repo/home/$path ]] || fail "wrong normalized source link: $path"
    done
    [[ -x $HOME/.config/agents/skills/nerd-fonts/tools/nerd-fonts-query.sh ]] || fail 'Nerd Fonts helper is not executable'
    for path in .pi .pi/agent .omp/agent; do
        [[ -d $HOME/$path && ! -L $HOME/$path ]] || fail "not a real private directory: $path"
        assert_eq "$(mode_of "$HOME/$path")" 700 "$path mode"
    done
    for path in .pi/agent/settings.json .omp/agent/config.yml .config/nvim/lazy-lock.json .config/fish/fish_plugins; do
        assert_regular "$HOME/$path"
        cmp "$repo/home/$path" "$HOME/$path"
    done
    for path in .pi/agent/settings.json .omp/agent/config.yml; do
        assert_eq "$(mode_of "$HOME/$path")" 600 "$path mode"
    done
    for path in .config/nvim/lazy-lock.json .config/fish/fish_plugins .gitconfig .config/jj/config.toml; do
        assert_eq "$(mode_of "$HOME/$path")" 644 "$path mode"
    done
    assert_absent "$HOME/.config/nvim/.neoconf.json"
    unexpected=$(find "$HOME" \( -name '*.tera' -o -name '.chezmoi*' -o -name '.chezmoiroot' \) -print)
    [[ -z $unexpected ]] || fail "deployed template/control sources: $unexpected"
    pass '2 normalized links, mutable copies, permissions, inactive sources'

    for agent in .pi .omp; do
        assert_eq "$(readlink "$HOME/$agent/agent/skills")" '../../.config/agents/skills'
        assert_eq "$(readlink "$HOME/$agent/agent/AGENTS.md")" '../../.config/agents/AGENTS.md'
    done
    # The real shared source already exists. Unlink its fixture deployment before
    # writing the target-only sentinel; never write through a checkout symlink.
    cp "$repo/home/.config/agents/AGENTS.md" "$fixture/AGENTS.source.expected"
    [[ -L $HOME/.config/agents/AGENTS.md ]] || fail 'shared AGENTS deployment should be a leaf link'
    rm "$HOME/.config/agents/AGENTS.md"
    for agent in .pi .omp; do
        [[ -L $HOME/$agent/agent/AGENTS.md && ! -e $HOME/$agent/agent/AGENTS.md ]] || fail 'agent link is not valid while its home referent is missing'
    done
    printf 'fixture-only agent instructions\n' >"$HOME/.config/agents/AGENTS.md"
    for agent in .pi .omp; do
        assert_text "$HOME/$agent/agent/AGENTS.md" 'fixture-only agent instructions'
    done
    cmp "$fixture/AGENTS.source.expected" "$repo/home/.config/agents/AGENTS.md"
    rm "$HOME/.config/agents/AGENTS.md"
    ln -s "$repo/home/.config/agents/AGENTS.md" "$HOME/.config/agents/AGENTS.md"
    pass '3 literal home-relative agent links, missing referents, target-only instructions'

    mkdir -p "$HOME/.pi/agent/sessions" "$HOME/.config/fish/functions" "$HOME/.config/nvim/lua"
    printf 'fixture auth\n' >"$HOME/.pi/agent/auth.json"
    printf 'fixture session\n' >"$HOME/.pi/agent/sessions/smoke.txt"
    printf '# fixture generated function\n' >"$HOME/.config/fish/functions/smoke-generated.fish"
    printf '%s\n' '-- fixture unmanaged Lua' >"$HOME/.config/nvim/lua/smoke-unmanaged.lua"
    apply
    assert_text "$HOME/.pi/agent/auth.json" 'fixture auth'
    assert_text "$HOME/.pi/agent/sessions/smoke.txt" 'fixture session'
    assert_text "$HOME/.config/fish/functions/smoke-generated.fish" '# fixture generated function'
    assert_text "$HOME/.config/nvim/lua/smoke-unmanaged.lua" '-- fixture unmanaged Lua'
    for path in .pi/agent/auth.json .pi/agent/sessions/smoke.txt .config/fish/functions/smoke-generated.fish .config/nvim/lua/smoke-unmanaged.lua; do
        assert_absent "$repo/home/$path"
    done
    cmp "$fixture/global.expected" "$MISE_CONFIG_DIR/config.toml"
    assert_absent "$MISE_DATA_DIR/installs/node"
    assert_applied
    pass '4 idempotence preserves runtime state without source-tree writes'
)

dry_run() (
    use_fixture preview
    mise -C "$repo" trust "$repo/mise.toml"
    if ! run_installer --dry-run >"$fixture/dry-run.log" 2>&1; then
        cat "$fixture/dry-run.log" >&2
        fail 'dry-run failed'
    fi
    assert_contains "$fixture/dry-run.log" dotfiles
    assert_contains "$fixture/dry-run.log" home
    assert_contains "$fixture/dry-run.log" 'agent-links.sh check'
    assert_contains "$fixture/dry-run.log" 'agent-links.sh apply'
    for path in .gitconfig .config/jj .config/nvim .config/fish .config/agents .pi .omp; do
        assert_absent "$HOME/$path"
    done
    assert_absent "$MISE_STATE_DIR/vars.toml"
    mise -C "$repo" dot diff "$HOME/.gitconfig" "$HOME/.config/jj/config.toml" >"$fixture/template.diff"
    assert_contains "$fixture/template.diff" 'nvonbulow'
    assert_contains "$fixture/template.diff" 'nick@nvonbulow.com'
    assert_contains "$fixture/template.diff" 'name = "nvonbulow"'
    assert_no_templates "$fixture/template.diff"
    if mise -C "$repo" dot status --missing >"$fixture/missing.status" 2>&1; then
        fail 'empty preview fixture unexpectedly reports applied dotfiles'
    else
        assert_eq "$?" 1 'native missing-status exit code'
    fi
    assert_contains "$fixture/missing.status" missing
    for path in .gitconfig .config/jj .config/nvim .config/fish .config/agents .pi .omp; do
        assert_absent "$HOME/$path"
    done
    assert_absent "$MISE_STATE_DIR/vars.toml"
    pass '5 dry-run prints group/hooks without targets or prompt answers; native diff renders'
)

identity_overrides() (
    use_fixture identity
    cp "$repo/home/.gitconfig.tera" "$fixture/git-template.expected"
    cp "$repo/home/.config/jj/config.toml.tera" "$fixture/jj-template.expected"
    mise -C "$repo" trust "$repo/mise.toml"
    mise -C "$repo" vars 'git_name=Migration Test' 'git_email=migration@example.invalid'
    apply
    assert_identity 'Migration Test' migration@example.invalid '"Migration Test"'
    mise -C "$repo" vars 'git_name=Migration "Quoted" \ Backslash' 'git_email=migration@example.invalid'
    apply
    assert_identity 'Migration "Quoted" \ Backslash' migration@example.invalid '"Migration \"Quoted\" \\ Backslash"'
    cmp "$fixture/git-template.expected" "$repo/home/.gitconfig.tera"
    cmp "$fixture/jj-template.expected" "$repo/home/.config/jj/config.toml.tera"
    assert_applied
    pass '6 persisted identity overrides and quote/backslash-safe Git/JJ templates'
)

safe_conflicts() (
    use_fixture file-conflict
    mkdir -p "$HOME/.config/nvim"
    printf 'keep conflicting init\n' >"$HOME/.config/nvim/init.lua"
    if run_installer >"$fixture/conflict.log" 2>&1; then
        fail 'noninteractive install overwrote a conflicting regular file'
    fi
    assert_regular "$HOME/.config/nvim/init.lua"
    assert_text "$HOME/.config/nvim/init.lua" 'keep conflicting init'
    assert_contains "$fixture/conflict.log" init.lua

    use_fixture agent-conflict
    mkdir -p "$HOME/.pi/agent"
    printf 'keep conflicting instructions\n' >"$HOME/.pi/agent/AGENTS.md"
    if run_installer >"$fixture/conflict.log" 2>&1; then
        fail 'agent pre-hook accepted a conflicting regular file'
    fi
    assert_regular "$HOME/.pi/agent/AGENTS.md"
    assert_text "$HOME/.pi/agent/AGENTS.md" 'keep conflicting instructions'
    assert_contains "$fixture/conflict.log" "$HOME/.pi/agent/AGENTS.md"
    assert_contains "$fixture/conflict.log" 'move'
    assert_absent "$HOME/.gitconfig"

    use_fixture parent-conflict
    mkdir -p "$HOME/.pi" "$fixture/parent-target"
    printf 'keep parent target\n' >"$fixture/parent-target/sentinel"
    ln -s "$fixture/parent-target" "$HOME/.pi/agent"
    for action in check apply; do
        if sh "$repo/scripts/agent-links.sh" "$action" >"$fixture/parent-$action.log" 2>&1; then
            fail "agent hook $action accepted a symlinked parent"
        fi
        assert_contains "$fixture/parent-$action.log" "$HOME/.pi/agent"
    done
    if run_installer >"$fixture/conflict.log" 2>&1; then
        fail 'installer accepted a symlinked private parent'
    fi
    assert_eq "$(readlink "$HOME/.pi/agent")" "$fixture/parent-target"
    assert_text "$fixture/parent-target/sentinel" 'keep parent target'
    assert_absent "$fixture/parent-target/skills"
    assert_absent "$fixture/parent-target/AGENTS.md"
    pass '7 regular-file, agent-link, and symlinked-parent conflicts preserve existing state'
)

managed_pruning() (
    use_fixture pruning
    printf '%s\n' '-- disposable managed leaf' >"$repo/home/.config/nvim/lua/smoke-pruned.lua"
    apply
    [[ -L $HOME/.config/nvim/lua/smoke-pruned.lua ]] || fail 'disposable managed leaf was not linked'
    printf '%s\n' '-- target-only neighbor' >"$HOME/.config/nvim/lua/smoke-neighbor.lua"
    rm "$repo/home/.config/nvim/lua/smoke-pruned.lua"
    apply
    assert_absent "$HOME/.config/nvim/lua/smoke-pruned.lua"
    assert_text "$HOME/.config/nvim/lua/smoke-neighbor.lua" '-- target-only neighbor'
    assert_absent "$repo/home/.config/nvim/lua/smoke-neighbor.lua"
    assert_applied
    pass '8 pruning removes recorded obsolete links, not unmanaged neighbors'
)

retired_integrations() (
    use_fixture retired
    apply
    for path in .local/bin/git .local/bin/gpg .config/wezterm .terminfo .zshenv .p10k.zsh .config/zsh .config/fsh; do
        assert_absent "$HOME/$path"
    done
    mkdir -p "$HOME/.config/wezterm" "$HOME/.terminfo" "$HOME/.config/zsh"
    printf 'keep legacy wezterm\n' >"$HOME/.config/wezterm/wezterm.lua"
    printf 'keep legacy terminfo\n' >"$HOME/.terminfo/smoke.txt"
    printf 'keep legacy zshenv\n' >"$HOME/.zshenv"
    printf 'keep legacy zsh config\n' >"$HOME/.config/zsh/smoke.zsh"
    apply
    assert_text "$HOME/.config/wezterm/wezterm.lua" 'keep legacy wezterm'
    assert_text "$HOME/.terminfo/smoke.txt" 'keep legacy terminfo'
    assert_text "$HOME/.zshenv" 'keep legacy zshenv'
    assert_text "$HOME/.config/zsh/smoke.zsh" 'keep legacy zsh config'
    for path in .config/wezterm/wezterm.lua .terminfo/smoke.txt .zshenv .config/zsh/smoke.zsh; do
        assert_absent "$repo/home/$path"
    done
    for path in .local/bin/git .local/bin/gpg .p10k.zsh .config/fsh; do
        assert_absent "$HOME/$path"
    done
    assert_applied
    pass '9 retired integrations stay undeployed and existing legacy files survive'
)

fish_activation() (
    use_fixture fish-activation
    mkdir -p "$HOME/.local/bin" "$HOME/.config/fish/conf.d" "$fixture/outside"
    cp "$shared_bin/mise" "$HOME/.local/bin/mise"
    cp "$repo/home/.config/fish/conf.d/mise-activate.fish" "$HOME/.config/fish/conf.d/mise-activate.fish"
    assert_absent "$MISE_CONFIG_DIR/config.toml"
    cd "$fixture/outside"
    PATH=/usr/bin:/bin "$fish_bin" --no-config --interactive --command '
        command -q mise; and exit 1
        source "$HOME/.config/fish/conf.d/mise-activate.fish"; or exit 1
        test "$MISE_SHELL" = fish; or exit 1
        functions -q mise; or exit 1
        functions -q __mise_env_eval; or exit 1
        test (command -s mise) = "$HOME/.local/bin/mise"; or exit 1
        set -l wrapper_before (functions mise | string collect)
        set -l hook_before (functions __mise_env_eval | string collect)
        source "$HOME/.config/fish/conf.d/mise-activate.fish"; or exit 1
        test "$MISE_SHELL" = fish; or exit 1
        functions -q mise; or exit 1
        functions -q __mise_env_eval; or exit 1
        test (command -s mise) = "$HOME/.local/bin/mise"; or exit 1
        test "$wrapper_before" = (functions mise | string collect); or exit 1
        test "$hook_before" = (functions __mise_env_eval | string collect); or exit 1
        mise --version >/dev/null; or exit 1
    '
    PATH=/usr/bin:/bin "$fish_bin" --no-config --command '
        source "$HOME/.config/fish/conf.d/mise-activate.fish"; or exit 1
        functions -q mise; and exit 1
        functions -q __mise_env_eval; and exit 1
        set -q MISE_SHELL; and exit 1
        exit 0
    '

    use_fixture fish-without-mise
    mkdir -p "$HOME/.config/fish/conf.d" "$fixture/outside"
    cp "$repo/home/.config/fish/conf.d/mise-activate.fish" "$HOME/.config/fish/conf.d/mise-activate.fish"
    assert_absent "$HOME/.local/bin/mise"
    cd "$fixture/outside"
    PATH=/usr/bin:/bin "$fish_bin" --no-config --interactive --command '
        command -q mise; and exit 1
        source "$HOME/.config/fish/conf.d/mise-activate.fish"; or exit 1
        functions -q mise; and exit 1
        functions -q __mise_env_eval; and exit 1
        set -q MISE_SHELL; and exit 1
        exit 0
    '
    pass '10 real Fish fallback activation, re-source idempotence, noninteractive/no-mise safety'
)

fresh_and_local_state
dry_run
identity_overrides
safe_conflicts
managed_pruning
retired_integrations
fish_activation
printf 'All isolated bootstrap scenarios passed (%s).\n' "$platform"
