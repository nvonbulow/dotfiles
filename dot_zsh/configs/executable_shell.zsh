
# Prevent nice(5) failed errors in WSL
case $(uname -a) in
    *Microsoft*) unsetopt BG_NICE ;;
esac
