#!/bin/zsh

local -a plugins=(
  marlonrichert/zsh-autocomplete
  zdharma-continuum/fast-syntax-highlighting
  zsh-users/zsh-autosuggestions
  asdf-vm/asdf
)

# Clone all plugins in parallel
znap clone $plugins

# Load each plugin
local p=
for p in $plugins; do
  znap source $p
done

