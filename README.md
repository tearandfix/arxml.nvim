# arxml.nvim

A Neovim plugin for [AUTOSAR](https://www.autosar.org/) ARXML files.

## Features

| Feature | Description |
|---|---|
| Filetype detection | `.arxml` files are automatically recognised |
| Smart folding | Fold by XML/AUTOSAR element depth |
| Syntax highlighting | `<SHORT-NAME>` values are emphasised; `UUID` attributes are dimmed |
| UUID-aware diff | Compare two ARXML files while ignoring UUID differences |
| Normalized diff | Same as UUID-aware diff, but also sorts elements by `SHORT-NAME` before comparing |
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

**With a file path** — compare the current buffer against any file:

```
:ARXMLDiff /path/to/other.arxml
```

Tab-completion works on the file path argument.

**Without arguments** — if exactly two ARXML buffers are visible in the current tab, they are used automatically:

```
:ARXMLDiff
```

Only visible windows are considered, so other ARXML buffers open in the background do not interfere. An error is shown if the number of visible ARXML buffers is not exactly two.

- Both panes are read-only scratch buffers; the original files are not touched.
- Close the diff tab with `:tabclose` when done.

The command is buffer-local and only available in `.arxml` buffers.

## Normalized diff

`:ARXMLNormilizedDiff` works identically to `:ARXMLDiff` but runs each buffer through `scripts/normalize_arxml.py` first, which sorts all named elements (those with a `<SHORT-NAME>` child) alphabetically before the diff is computed. This makes structural differences visible even when the two files have elements in different orders.

```
:ARXMLNormilizedDiff /path/to/other.arxml   " compare current buffer against a file
:ARXMLNormilizedDiff                        " use the two visible ARXML buffers
```

Requires Python 3 and `lxml` (`pip install lxml`).

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
