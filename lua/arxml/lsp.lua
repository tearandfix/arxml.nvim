local M = {}

-- Search runtimepath for the companion arxml-lsp Python package.
-- Returns the directory that contains the arxml_lsp/ package, or nil.
local function find_server_root()
  for _, rtp in ipairs(vim.api.nvim_list_runtime_paths()) do
    if vim.uv.fs_stat(rtp .. "/arxml_ls/__main__.py") then
      return rtp
    end
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
      local server_root = find_server_root()
      if not server_root then
        return
      end

      vim.lsp.start({
        name     = "arxml-ls",
        cmd      = { "python3", "arxml_ls.py" },
        cmd_env  = { PYTHONPATH = server_root },
        root_dir = get_root(ev.buf),
      }, { bufnr = ev.buf })
    end,
  })
end

return M
