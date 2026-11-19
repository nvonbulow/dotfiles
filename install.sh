#!/bin/sh

set -eu

# POSIX script-directory resolution; callers may run this outside the checkout.
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"
case "$(uname -s)" in
  Darwin|Linux) ;;
  *) echo "mise dotfiles support only macOS and Linux." >&2; exit 1 ;;
esac

if command -v mise >/dev/null 2>&1; then
  mise=$(command -v mise)
elif [ -x "$HOME/.local/bin/mise" ]; then
  mise="$HOME/.local/bin/mise"
else
  mise="$HOME/.local/bin/mise"
  installer=$(mktemp)
  trap 'rm -f "$installer"' EXIT HUP INT TERM
  if command -v curl >/dev/null 2>&1; then
    curl -fsSL https://mise.run -o "$installer"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$installer" https://mise.run
  else
    echo "Installing mise requires curl or wget." >&2
    exit 1
  fi
  MISE_VERSION=v2026.11.8 MISE_INSTALL_PATH="$mise" sh "$installer"
  rm -f "$installer"
  trap - EXIT HUP INT TERM
fi

version=$("$mise" --version)
version=${version%% *}
if ! printf '%s\n' "$version" | awk -F. '
  NF != 3 || $1 !~ /^[0-9]+$/ || $2 !~ /^[0-9]+$/ || $3 !~ /^[0-9]+$/ { exit 1 }
  { exit !(($1 > 2026) || ($1 == 2026 && $2 > 11) || ($1 == 2026 && $2 == 11 && $3 >= 8)) }
'; then
  echo "mise 2026.11.8 or newer is required (found $version); upgrade mise and retry." >&2
  exit 1
fi

"$mise" trust "$script_dir/mise.toml"
dry_run=false
for arg do
  case "$arg" in --dry-run|-n) dry_run=true ;; esac
done
if [ -t 0 ] && [ -t 1 ]; then
  if [ "$dry_run" = false ]; then
    set -- --prompt-vars "$@"
  fi
else
  set -- --yes "$@"
fi
exec "$mise" -C "$script_dir" bootstrap --only files,dotfiles --prune-dotfiles "$@"
