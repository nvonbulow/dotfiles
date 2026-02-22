# AGENTS.md

Guidelines for coding agents working in this Neovim configuration repository.

## Project Overview

Neovim configuration based on kickstart.nvim using lazy.nvim as the plugin manager.

## Build/Lint Commands

### Formatting (Lua)

```bash
stylua .              # Format all Lua files
stylua --check .      # Check formatting (used in CI)
```

### Health Check

Run in Neovim: `:checkhealth kickstart`

### Plugin Management

Run in Neovim: `:Lazy` to open plugin manager, then `:Lazy update` to update.

## Code Style Guidelines

### Formatting (stylua)

From `.stylua.toml`:
- Column width: 160 characters
- Indentation: 2 spaces
- Quote style: AutoPreferSingle
- Call parentheses: None
- Collapse simple statements: Always

### Imports

```lua
local dap = require 'dap'
require('telescope').setup { ... }
```

Omit parentheses for simple requires. Use parentheses when chaining.

### Strings

Use single quotes. Use double quotes when string contains single quotes:

```lua
vim.g.mapleader = ' '
vim.opt.listchars = { tab = "» ", trail = "·" }
```

### Plugin Specifications

Return a table from plugin files:

```lua
return {
  {
    'author/plugin-name',
    event = 'VimEnter',
    opts = { option = 'value' },
    config = function()
      require('plugin').setup { ... }
    end,
    dependencies = { 'dependency/plugin' },
    keys = {
      { '<leader>x', function() end, desc = 'Description' },
    },
  },
}
```

### Keymaps

Always include `desc` with bracketed mnemonic hints:

```lua
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
```

### Autocommands

Use augroups:

```lua
local augroup = vim.api.nvim_create_augroup('group-name', { clear = true })
vim.api.nvim_create_autocmd('EventType', {
  group = augroup,
  desc = 'Description',
  callback = function() end,
})
```

### Error Handling

Use `pcall` for optional features. Use `vim.fn.executable` to check for external tools.

### Options

Use `vim.o` for simple options, `vim.opt` for table-like options:

```lua
vim.o.number = true
vim.opt.listchars = { tab = '» ', trail = '·' }
```

### Windows Compatibility

```lua
if vim.fn.has 'win32' == 1 then end
detached = vim.fn.has 'win32' == 0,
```

### Comments

- Single-line: `-- comment`
- Multi-line: `--[[ comment ]]`
- Prefixes: `NOTE:`, `TIP:`, `WARNING:`

## File Structure

```
.
├── init.lua                    # Main entry point
├── lua/
│   ├── kickstart/
│   │   ├── health.lua          # Health check module
│   │   └── plugins/            # Optional plugin configs
│   └── custom/plugins/         # User custom plugins
├── .stylua.toml                # Formatter config
└── lazy-lock.json              # Plugin lock file
```

## Plugin Configuration Pattern

1. **Simple**: `opts = {}`
2. **Complex**: `config = function() ... end`
3. **Keymaps**: Define in `keys` table
4. **Dependencies**: List in `dependencies` array
5. **Lazy loading**: Use `event`, `cmd`, `ft`, or `keys`

## Leader Keys

- `<leader>`: Space (` `)
- `<localleader>`: Space (` `)

## Commit Messages

Use conventional commit format with lowercase type and imperative mood:
- `feat: add new feature`
- `fix: resolve bug`
- `docs: update documentation`
- `chore: maintenance tasks`
- `refactor: code restructuring`
- `style: formatting changes`

## External Dependencies

- Required: `git`, `make`, `unzip`, `rg`
- Recommended: `fd`
- Optional: Nerd Font (set `vim.g.have_nerd_font = true`)