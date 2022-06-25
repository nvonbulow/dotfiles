setopt completealiases

alias zshconfig="edit ~/.zshrc"
alias zshsource="source ~/.zshrc"

function colormap {
    for i in {0..255}; do
        print -Pn ${(l:3::0:)i}" "%K{$i}"  "%k%F{$i}test%f" "${${(M)$(((i+1)%8)):#0}:+$'\n'};
    done
}

# open command to mimic that on Mac
# all output is also not shown on the terminal
function open {
    xdg-open $@ 1> /dev/null 2>&1 &!
}

# Git aliases

if whence -w git | grep alias > /dev/null; then
    unalias git
fi

# If exa is installed, alias ls to it
if [ "$(command -v exa)" ]; then
    alias ls="exa --icons"
fi

# Are we running on WSL?
if [[ -d "/mnt/c/Windows" ]]; then
    # autogit will use Windows git in Windows directories and WSL git in Linux directories
    function _install_autogit {
        alias cmd="/mnt/c/Windows/System32/cmd.exe"
        alias git-wsl="$(which git)"
        alias git="_wsl_autogit"
    }
fi


function git-cleanup {
    git fetch --prune && git branch -vv | grep ': gone]' | grep -v "\*" | awk '{ print $1 }' | xargs git branch -D
}

# oh-my-zsh directory aliases
zplug "lib/directories", from:oh-my-zsh

