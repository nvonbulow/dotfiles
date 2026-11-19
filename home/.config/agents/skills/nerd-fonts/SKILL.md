---
name: nerd-fonts
description: Look up Nerd Font glyph names by codepoint and search codepoints by glyph name using fzf fuzzy scoring; supports multiple queries per invocation.
---

# Nerd Fonts Skill

Use this skill when you need to map between Nerd Font glyph names and codepoints.

## Assets in this skill

- Database copy: [data/glyphnames.json](data/glyphnames.json)
- Query tool: [tools/nerd-fonts-query.sh](tools/nerd-fonts-query.sh)

## Capabilities

1. Lookup glyph name(s) by codepoint (`--codepoint`)
2. Fuzzy-search by glyph name to find codepoints (`--name`, uses `fzf` scoring)
3. Run multiple lookups/searches in one command

## Usage

```bash
tools/nerd-fonts-query.sh --codepoint f179
tools/nerd-fonts-query.sh --codepoint f179 --codepoint 0xe5ff
tools/nerd-fonts-query.sh --name github --name docker --limit 5
tools/nerd-fonts-query.sh --codepoint e5ff --name lock --name terminal --limit 5
```

## Notes

- Codepoints accept `f179`, `0xf179`, and `\\uf179` forms.
- `--limit` controls max matches per `--name` query (default `10`).
- Requires `jq` and `fzf` on `PATH`.
