# Bootstrap fisher and install plugins from fish_plugins on first interactive run.
status is-interactive; or return

if functions -q fisher
    return
end

if not command -q curl
    return
end

curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
fisher install jorgebucaran/fisher

if test -f ~/.config/fish/fish_plugins
    fisher update
end
