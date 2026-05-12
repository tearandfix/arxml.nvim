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

map('<leader>a', vim.lsp.buf.code_action,    'LSP code action')
map('<leader>r', vim.lsp.buf.rename,         'LSP rename symbol')
map('gd',        vim.lsp.buf.definition,     'LSP go to definition')
map('gi',        vim.lsp.buf.implementation, 'LSP go to implementation')
map('gr',        function() require('telescope.builtin').lsp_references() end, 'LSP references')
map('gh',        vim.lsp.buf.hover,          'LSP hover')

vim.diagnostic.config({ virtual_text = false })
vim.o.updatetime = 250

vim.api.nvim_create_autocmd('CursorHold', {
  buffer = 0,
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false })
  end,
})

vim.api.nvim_buf_create_user_command(0, 'ARXMLDiff', function(opts)
  require('arxml.diff').open(vim.api.nvim_get_current_buf(), opts.args)
end, { nargs = 1, complete = 'file', desc = 'Diff ARXML files ignoring UUID values' })

