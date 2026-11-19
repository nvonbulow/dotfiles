# Bootstrap fisher function on first interactive run.
# We intentionally do not auto-install plugins here to avoid Tide's
# first-install interactive wizard during shell startup.
status is-interactive; or return

if functions -q fisher
    return
end

if not command -q curl
    return
end

set -l fisher_fn ~/.config/fish/functions/fisher.fish
mkdir -p (dirname $fisher_fn)
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish -o $fisher_fn
source $fisher_fn

echo "[fish] Fisher bootstrapped. Run 'fisher update' to install plugins from fish_plugins."
