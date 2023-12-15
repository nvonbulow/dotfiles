#!/bin/zsh

##
# Set up named directories
#
hash -d zsh=$ZDOTDIR
hash -d nvim=~/.config/nvim
hash -d repos=~/Documents/repos
hash -d projects=~/Documents/projects
# `hash -d <name>=<path>` makes ~<name> a shortcut for <path>.
# You can use this ~name anywhere you would specify a dir, not just with `cd`!
