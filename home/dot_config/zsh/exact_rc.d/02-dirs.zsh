#!/bin/zsh

##
# Set up named directories
#
hash -d config=~/.config
hash -d c=~config
hash -d zsh=$ZDOTDIR
hash -d nvim=~c/nvim
hash -d wezterm=~c/wezterm
hash -d tmux=~c/tmux
hash -d repos=~/Documents/repos
hash -d projects=~/Documents/projects
hash -d tutorials=~/Documents/tutorials
# `hash -d <name>=<path>` makes ~<name> a shortcut for <path>.
# You can use this ~name anywhere you would specify a dir, not just with `cd`!
