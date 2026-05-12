local M = {}

-- arxml-ls is installed by lazy.nvim as a sibling of arxml.nvim.
-- Resolve its entry-point script relative to this file's own location:
--   <lazy-dir>/arxml.nvim/lua/arxml/lsp.lua  →  4 levels up  →  <lazy-dir>
local function find_server_script()
  local this_file = debug.getinfo(1, "S").source:sub(2) -- strip leading '@'
  local lazy_dir = vim.fn.fnamemodify(this_file, ":h:h:h:h")
  local script = lazy_dir .. "/arxml-ls/arxml_ls.py"
  if vim.uv.fs_stat(script) then
    return script
  end
end

local function get_root(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  local dir = vim.fn.fnamemodify(path, ":h")
  local found = vim.fs.find({ ".git" }, { upward = true, path = dir, stop = vim.env.HOME })
  return found[1] and vim.fn.fnamemodify(found[1], ":h") or dir
end

function M.setup()
  local group = vim.api.nvim_create_augroup("ArxmlLsp", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "arxml",
    callback = function(ev)
      local server_script = find_server_script()
      if not server_script then
        return
      end

      vim.lsp.start({
        name     = "arxml-ls",
        cmd      = { "python3", server_script },
        cmd_env  = { PYTHONPATH = vim.fn.fnamemodify(server_script, ":h") },
        root_dir = get_root(ev.buf),
      }, { bufnr = ev.buf })
    end,
  })
end

return M
