if vim.g.loaded_arxml then
  return
end
vim.g.loaded_arxml = true

require("arxml").setup()
