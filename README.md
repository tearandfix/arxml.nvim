# arxml.nvim

A Neovim plugin for [AUTOSAR](https://www.autosar.org/) ARXML files.

## Features

| Feature | Description |
|---|---|
| Filetype detection | `.arxml` files are automatically recognised |
| Smart folding | Fold by XML/AUTOSAR element depth |
| Syntax highlighting | `<SHORT-NAME>` values are emphasised; `UUID` attributes are dimmed |
| UUID-aware diff | Compare two ARXML files while ignoring UUID differences |
| LSP | Auto-starts the ARXML language server when the companion plugin is installed |

## Requirements

- Neovim ≥ 0.9
- (Optional) [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) with the `xml` parser for richer syntax
- (Optional) [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) for the `gr` LSP references picker

## Installation

### lazy.nvim

```lua
{
  "tearandfix/arxml.nvim",
  dependencies = { "tearandfix/arxml_ls" },  -- optional: adds LSP support
  ft = "arxml"
}
```

The `arxml_ls` dependency is optional. When present, the language server starts
automatically for every `.arxml` buffer — no extra configuration required.

### Manual / packer

```lua
use {
  "tearandfix/arxml.nvim",
  config = function()
    require("arxml").setup()
  end,
}
```

## UUID-aware diff

When two ARXML files differ only in regenerated UUIDs it can be hard to spot
the real structural changes.  The `:ARXMLDiff` command opens a side-by-side
diff in a new tab with all `UUID="…"` attribute values replaced by `UUID=""`
before the diff is computed, so UUID-only changes are invisible to the diff
engine.

```
:ARXMLDiff /path/to/other.arxml
```

- Tab-completion works on the file path argument.
- Both panes are read-only scratch buffers; the original files are not touched.
- Close the diff tab with `:tabclose` when done.

The command is buffer-local and only available in `.arxml` buffers.

## Keybindings

All keybindings are buffer-local and only active in `.arxml` files.

### LSP

| Key | Action |
|---|---|
| `<leader>a` | Code action |
| `<leader>r` | Rename symbol |
| `gd` | Go to definition |
| `gi` | Go to implementation |
| `gr` | List references (telescope) |
| `gh` | Hover documentation |

Inline virtual-text diagnostics are disabled in favour of a floating window
that appears automatically when the cursor rests on a line (`updatetime=250`).

## Configuration

```lua
require("arxml").setup({
})
```

## License

MIT
