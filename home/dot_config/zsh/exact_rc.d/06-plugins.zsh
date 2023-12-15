#!/bin/zsh

local -a plugins=(
  marlonrichert/zsh-autocomplete
  zdharma-continuum/fast-syntax-highlighting
  zsh-users/zsh-autosuggestions
)

# Clone all plugins in parallel
znap clone $plugins

# Load each plugin
local p=
for p in $plugins; do
  znap source $p
done

