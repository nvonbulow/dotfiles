
CASE_SENSITIVE=false
HYPHEN_INSENSITIVE=true

if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# oh-my-zsh style completion (case-insensitive, etc.)
zplug 'lib/completion', from:oh-my-zsh

# zplug 'marlonrichert/zsh-autocomplete', defer:2
# Enhanced version of the cd command with fuzzy search
# zplug 'b4b4r07/enhancd', use:init.sh
