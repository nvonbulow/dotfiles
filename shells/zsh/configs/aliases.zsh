alias zshconfig="edit ~/.zshrc"
alias zshsource="source ~/.zshrc"
alias colormap='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done'
case $(uname -a) in
    *microsoft*) alias cmd="/mnt/c/Windows/System32/cmd.exe"
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

# oh-my-zsh directory aliases
zplug "lib/directories", from:oh-my-zsh

