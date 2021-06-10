alias zshconfig="edit ~/.zshrc"
alias zshsource="source ~/.zshrc"
alias colormap='for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done'
case $(uname -a) in
    *microsoft*) alias cmd="/mnt/c/Windows/System32/cmd.exe" ;;
esac

# oh-my-zsh directory aliases
zplug "lib/directories", from:oh-my-zsh

