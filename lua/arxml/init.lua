local M = {}

M.config = {
  -- Highlight SHORT-NAME values distinctly
  highlight_short_names = true,
}

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  if M.config.highlight_short_names then
    require("arxml.highlight").setup()
  end

  require("arxml.lsp").setup()

  -- Register the custom filetype with Neovim's filetype system
  vim.filetype.add({ extension = { arxml = "arxml" } })
end

return M
