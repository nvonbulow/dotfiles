#!/bin/sh
set -eu

case "${1-}" in
  check|apply) action=$1 ;;
  *) echo "Usage: $0 check|apply" >&2; exit 2 ;;
esac
[ "$#" -eq 1 ] || { echo "Usage: $0 check|apply" >&2; exit 2; }

# Check every parent before touching any link; never follow directory symlinks.
for parent in "$HOME/.pi" "$HOME/.pi/agent" "$HOME/.omp" "$HOME/.omp/agent"; do
  if [ -L "$parent" ] || { [ -e "$parent" ] && [ ! -d "$parent" ]; }; then
    echo "Invalid agent directory: $parent; move it aside before deployment." >&2
    exit 1
  fi
  if [ "$action" = apply ] && [ ! -d "$parent" ]; then
    echo "Missing agent directory: $parent; run bootstrap with --only files,dotfiles." >&2
    exit 1
  fi
done

# Validate all four first so an ordinary conflict never partially repoints links.
for agent in .pi .omp; do
  for name in skills AGENTS.md; do
    path="$HOME/$agent/agent/$name"
    if [ -e "$path" ] && [ ! -L "$path" ]; then
      echo "Agent link conflict: $path; move it aside before deployment." >&2
      exit 1
    fi
  done
done
[ "$action" = apply ] || exit 0

for agent in .pi .omp; do
  for name in skills AGENTS.md; do
    path="$HOME/$agent/agent/$name"
    target="../../.config/agents/$name"
    if [ -L "$path" ]; then
      [ "$(readlink "$path")" = "$target" ] && continue
      rm "$path"
    elif [ -e "$path" ]; then
      echo "Agent link conflict: $path; move it aside before deployment." >&2
      exit 1
    fi
    ln -s "$target" "$path"
  done
done
