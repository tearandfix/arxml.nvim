# arxml.nvim

A Neovim plugin for [AUTOSAR](https://www.autosar.org/) ARXML files.

## Features

| Feature | Description |
|---|---|
| Filetype detection | `.arxml` files are automatically recognised |
| Syntax highlighting | AUTOSAR-specific tags (`SHORT-NAME`, `*-REF`, packages, …) highlighted on top of XML |
| Smart folding | Fold by XML/AUTOSAR element depth |
| LSP | Auto-starts the ARXML language server when the companion plugin is installed |

## Requirements

- Neovim ≥ 0.9
- (Optional) [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) with the `xml` parser for richer syntax

## Installation

### lazy.nvim

```lua
{
  "tearandfix/arxml.nvim",
  dependencies = { "tearandfix/arxml_ls" },  -- optional: adds LSP support
  ft = "arxml",
  opts = {
    -- all options are optional; these are the defaults
    highlight_short_names = true,
  },
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

## Keybindings

All keybindings are buffer-local and only active in `.arxml` files.

## Configuration

```lua
require("arxml").setup({
  -- Highlight SHORT-NAME values as identifiers and *-REF values as links
  highlight_short_names = true,
})
```

## License

MIT
