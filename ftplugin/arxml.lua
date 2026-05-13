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

local function get_two_arxml_bufs()
  local seen = {}
  local bufs = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local b = vim.api.nvim_win_get_buf(win)
    if not seen[b] and vim.bo[b].filetype == 'arxml' then
      seen[b] = true
      bufs[#bufs + 1] = b
    end
  end
  if #bufs ~= 2 then
    vim.notify('ARXMLDiff: expected exactly 2 visible ARXML buffers, found ' .. #bufs, vim.log.levels.ERROR)
    return nil
  end
  return bufs
end

vim.api.nvim_buf_create_user_command(0, 'ARXMLDiff', function(opts)
  if opts.args ~= '' then
    require('arxml.diff').open(vim.api.nvim_get_current_buf(), opts.args)
  else
    local bufs = get_two_arxml_bufs()
    if bufs then require('arxml.diff').open_bufs(bufs[1], bufs[2]) end
  end
end, { nargs = '?', complete = 'file', desc = 'Diff ARXML files ignoring UUID values' })

vim.api.nvim_buf_create_user_command(0, 'ARXMLNormilizedDiff', function(opts)
  if opts.args ~= '' then
    require('arxml.diff').open_normalized(vim.api.nvim_get_current_buf(), opts.args)
  else
    local bufs = get_two_arxml_bufs()
    if bufs then require('arxml.diff').open_bufs_normalized(bufs[1], bufs[2]) end
  end
end, { nargs = '?', complete = 'file', desc = 'Diff ARXML files sorted by SHORT-NAME, ignoring UUID values' })

