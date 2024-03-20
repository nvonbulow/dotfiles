#!/bin/zsh

local -a plugins=(
  marlonrichert/zsh-autocomplete
  zdharma-continuum/fast-syntax-highlighting
  zsh-users/zsh-autosuggestions
  jeffreytse/zsh-vi-mode
)

# zsh-vi-mode configuration
export ZVM_VI_EDITOR=nvim

# Clone all plugins in parallel
znap clone $plugins

# Load each plugin
local p=
for p in $plugins; do
  znap source $p
done

