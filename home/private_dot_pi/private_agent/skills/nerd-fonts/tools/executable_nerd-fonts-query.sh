#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB_PATH="${SCRIPT_DIR}/../data/glyphnames.json"

if [[ ! -f "${DB_PATH}" ]]; then
  echo "Error: database not found at ${DB_PATH}" >&2
  exit 1
fi

usage() {
  cat <<'EOF'
Query Nerd Font glyph names and codepoints.

Usage:
  nerd-fonts-query.sh [--limit N] [--codepoint CP ...] [--name QUERY ...]

Options:
  --codepoint CP   Lookup one codepoint (hex, with or without 0x/\u prefix).
                   Repeat this option for multiple lookups.
  --name QUERY     Fuzzy-search glyph names using fzf scoring.
                   Repeat this option for multiple queries.
  --limit N        Max number of fuzzy matches per --name query (default: 10).
  -h, --help       Show this help.
EOF
}

normalize_cp() {
  local cp="$1"
  cp="${cp#0x}"
  cp="${cp#0X}"
  cp="${cp#\\u}"
  cp="${cp#\\U}"
  cp="${cp^^}"
  if [[ ! "$cp" =~ ^[0-9A-F]+$ ]]; then
    return 1
  fi
  printf "%s" "$cp"
}

if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is required" >&2
  exit 1
fi

limit=10
codepoints=()
names=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --codepoint)
      [[ $# -ge 2 ]] || { echo "Error: --codepoint requires a value" >&2; exit 1; }
      codepoints+=("$2")
      shift 2
      ;;
    --name)
      [[ $# -ge 2 ]] || { echo "Error: --name requires a value" >&2; exit 1; }
      names+=("$2")
      shift 2
      ;;
    --limit)
      [[ $# -ge 2 ]] || { echo "Error: --limit requires a value" >&2; exit 1; }
      limit="$2"
      if [[ ! "$limit" =~ ^[0-9]+$ ]] || [[ "$limit" -le 0 ]]; then
        echo "Error: --limit must be a positive integer" >&2
        exit 1
      fi
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ ${#codepoints[@]} -eq 0 && ${#names[@]} -eq 0 ]]; then
  usage >&2
  exit 1
fi

for raw_cp in "${codepoints[@]}"; do
  cp="$(normalize_cp "$raw_cp")" || {
    echo "[codepoint:$raw_cp] invalid codepoint" >&2
    continue
  }

  echo "### codepoint:${cp}"
  jq -r --arg cp_lc "${cp,,}" '
    to_entries
    | map(select(.key != "METADATA" and (.value.code | ascii_downcase) == $cp_lc))
    | if length == 0 then
        "(no match)"
      else
        .[] | "\(.key)\tU+\(.value.code | ascii_upcase)\t\(.value.char)"
      end
  ' "$DB_PATH"
  echo

done

if [[ ${#names[@]} -gt 0 ]]; then
  if ! command -v fzf >/dev/null 2>&1; then
    echo "Error: fzf is required for --name queries" >&2
    exit 1
  fi

  for query in "${names[@]}"; do
    echo "### name:${query}"
    jq -r '
      to_entries[]
      | select(.key != "METADATA")
      | "\(.key)\tU+\(.value.code | ascii_upcase)\t\(.value.char)"
    ' "$DB_PATH" \
      | fzf --filter "$query" --delimiter $'\t' --with-nth '1,2' \
      | head -n "$limit" \
      || true

    echo
  done
fi
