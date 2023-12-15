#!/bin/zsh

##
# Plugin manager
#

ZNAP_HOME=~/.zsh/znap
ZNAP_CACHE=~/.cache/znap
[[ -r $ZNAP_HOME/znap.zsh ]] ||
  git clone https://github.com/marlonrichert/zsh-snap.git $ZNAP_HOME

mkdir -p $ZNAP_CACHE
zstyle ':znap:*' repos-dir $ZNAP_CACHE

source $ZNAP_HOME/znap.zsh

source ~/.p10k.zsh
znap prompt romkatv/powerlevel10k

znap source marlonrichert/zsh-autocomplete
znap source zdharma-continuum/fast-syntax-highlighting
