if vim.b.did_ftplugin_arxml then
  return
end
vim.b.did_ftplugin_arxml = true

vim.bo.commentstring = "<!-- %s -->"

-- matchit: enable % to jump between matching XML tags
vim.b.match_ignorecase = 0
vim.cmd([=[
  let b:match_words =
   \  '<:>,' .
   \  '<\@<=!\[CDATA\[:]]>,' .
   \  '<\@<=!--:-->,' .
   \  '<\@<=?\k\+:?>,' .
   \  '<\@<=\([^ \t>/]\+\)\%(\s\+[^>]*\%([^/]>\|$\)\|>\|$\):<\@<=/\1>,' .
   \  '<\@<=\%([^ \t>/]\+\)\%(\s\+[^/>]*\|$\):/>'
]=])
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

vim.api.nvim_buf_create_user_command(0, 'ARXMLDiff', function(opts)
  require('arxml.diff').open(vim.api.nvim_get_current_buf(), opts.args)
end, { nargs = 1, complete = 'file', desc = 'Diff ARXML files ignoring UUID values' })

