
# Prevent nice(5) failed errors in WSL
case $(uname -a) in
    *Microsoft*) unsetopt BG_NICE ;;
esac

# iTerm2 shell integration on MacOS
if [[ -f $HOME/.zsh/iterm2_integration.zsh ]]; then
    source $HOME/.zsh/iterm2_integration.zsh
fi
