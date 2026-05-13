local M = {}

local plugin_root = vim.fn.fnamemodify(
  debug.getinfo(1, 'S').source:sub(2), ':p:h:h:h'
)

local function normalize_lines(lines)
  local script = plugin_root .. '/scripts/normalize_arxml.py'
  local tmp_in  = vim.fn.tempname() .. '.arxml'
  local tmp_out = vim.fn.tempname() .. '.arxml'
  vim.fn.writefile(lines, tmp_in)
  local err = vim.fn.system({ 'python3', script, tmp_in, '-o', tmp_out })
  vim.fn.delete(tmp_in)
  if vim.v.shell_error ~= 0 then
    vim.fn.delete(tmp_out)
    vim.notify('ARXMLDiff: normalization failed:\n' .. err, vim.log.levels.ERROR)
    return nil
  end
  local result = vim.fn.readfile(tmp_out)
  vim.fn.delete(tmp_out)
  return result
end

local function strip_uuids(lines)
  return vim.tbl_map(function(line)
    return line:gsub('UUID%s*=%s*"[^"]*"', 'UUID=""')
  end, lines)
end

local function make_diff_buf(lines, label)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, strip_uuids(lines))
  vim.api.nvim_buf_set_name(buf, '[arxml-diff] ' .. vim.fn.fnamemodify(label, ':p'))
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].filetype = 'arxml'
  vim.bo[buf].modifiable = false
  return buf
end

local function open_diff_tab(dbuf_a, dbuf_b)
  vim.cmd('tabnew')
  vim.api.nvim_win_set_buf(0, dbuf_a)
  vim.cmd('diffthis')
  vim.cmd('vsplit')
  vim.api.nvim_win_set_buf(0, dbuf_b)
  vim.cmd('diffthis')
  vim.cmd('wincmd p')
end

function M.open(source_buf, other_path)
  other_path = vim.fn.expand(other_path)
  if vim.fn.filereadable(other_path) == 0 then
    vim.notify('ARXMLDiff: cannot read ' .. other_path, vim.log.levels.ERROR)
    return
  end

  local lines_a = vim.api.nvim_buf_get_lines(source_buf, 0, -1, false)
  local name_a = vim.api.nvim_buf_get_name(source_buf)
  if name_a == '' then name_a = '[No Name]' end
  local lines_b = vim.fn.readfile(other_path)

  open_diff_tab(make_diff_buf(lines_a, name_a), make_diff_buf(lines_b, other_path))
end

function M.open_bufs(buf_a, buf_b)
  local lines_a = vim.api.nvim_buf_get_lines(buf_a, 0, -1, false)
  local name_a = vim.api.nvim_buf_get_name(buf_a)
  if name_a == '' then name_a = '[No Name]' end
  local lines_b = vim.api.nvim_buf_get_lines(buf_b, 0, -1, false)
  local name_b = vim.api.nvim_buf_get_name(buf_b)
  if name_b == '' then name_b = '[No Name]' end

  open_diff_tab(make_diff_buf(lines_a, name_a), make_diff_buf(lines_b, name_b))
end

function M.open_normalized(source_buf, other_path)
  other_path = vim.fn.expand(other_path)
  if vim.fn.filereadable(other_path) == 0 then
    vim.notify('ARXMLDiff: cannot read ' .. other_path, vim.log.levels.ERROR)
    return
  end

  local lines_a = normalize_lines(vim.api.nvim_buf_get_lines(source_buf, 0, -1, false))
  if not lines_a then return end
  local name_a = vim.api.nvim_buf_get_name(source_buf)
  if name_a == '' then name_a = '[No Name]' end
  local lines_b = normalize_lines(vim.fn.readfile(other_path))
  if not lines_b then return end

  open_diff_tab(make_diff_buf(lines_a, name_a), make_diff_buf(lines_b, other_path))
end

function M.open_bufs_normalized(buf_a, buf_b)
  local lines_a = normalize_lines(vim.api.nvim_buf_get_lines(buf_a, 0, -1, false))
  if not lines_a then return end
  local name_a = vim.api.nvim_buf_get_name(buf_a)
  if name_a == '' then name_a = '[No Name]' end
  local lines_b = normalize_lines(vim.api.nvim_buf_get_lines(buf_b, 0, -1, false))
  if not lines_b then return end
  local name_b = vim.api.nvim_buf_get_name(buf_b)
  if name_b == '' then name_b = '[No Name]' end

  open_diff_tab(make_diff_buf(lines_a, name_a), make_diff_buf(lines_b, name_b))
end

return M
