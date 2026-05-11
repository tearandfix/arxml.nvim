if vim.b.did_ftplugin_arxml then
  return
end
vim.b.did_ftplugin_arxml = true

vim.bo.commentstring = "<!-- %s -->"
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.expandtab = true

-- XML-compatible folding
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.require('arxml.fold').foldexpr(v:lnum)"
vim.wo.foldtext = "v:lua.require('arxml.fold').foldtext()"
vim.wo.foldlevel = 99

local map = function(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { buffer = true, silent = true, desc = desc })
end

