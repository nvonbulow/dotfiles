setopt completealiases

alias zshconfig="edit ~/.zshrc"
alias zshsource="source ~/.zshrc"

function colormap {
    for i in {0..255}; do
        print -Pn ${(l:3::0:)i}" "%K{$i}"  "%k%F{$i}test%f" "${${(M)$(((i+1)%8)):#0}:+$'\n'};
    done
}

# Git aliases

if whence -w git | grep alias > /dev/null; then
    unalias git
fi

case $(uname -a) in
    *WSL*) alias cmd="/mnt/c/Windows/System32/cmd.exe"
                 alias git_wsl="$(which git)"
                 alias git="_wsl_autogit" ;;
esac

# Autocomplete does not work in Windows directories yet
function _wsl_autogit {
    if [[ "${PWD##/mnt/}" != "${PWD}" ]]; then
        cmd /c git $@
    else
        git_wsl $@
    fi
}

function git-cleanup {
    git fetch --prune && git branch -vv | grep ': gone]' | grep -v "\*" | awk '{ print $1 }' | xargs git branch -D
}

# oh-my-zsh directory aliases
zplug "lib/directories", from:oh-my-zsh

