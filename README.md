# arxml.nvim

A Neovim plugin for [AUTOSAR](https://www.autosar.org/) ARXML files.

## Features

| Feature | Description |
|---|---|
| Filetype detection | `.arxml` files are automatically recognised |
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

## Keybindings

All keybindings are buffer-local and only active in `.arxml` files.

## Configuration

```lua
require("arxml").setup({
})
```

## License

MIT
