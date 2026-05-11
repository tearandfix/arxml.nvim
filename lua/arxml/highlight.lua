local M = {}

local ns = vim.api.nvim_create_namespace("arxml_highlight")

local HL_GROUPS = {
  ArxmlShortName      = { link = "Identifier" },
  ArxmlCategory      = { link = "Special" },
  ArxmlAdminData     = { link = "Comment" },
  ArxmlPackagePath   = { link = "Directory" },
  ArxmlRef           = { link = "Underlined" },
}

local function define_highlights()
  for name, attrs in pairs(HL_GROUPS) do
    if vim.fn.hlexists(name) == 0 then
      vim.api.nvim_set_hl(0, name, attrs)
    end
  end
end

-- Pattern-based highlighting for SHORT-NAME tags and *-REF tags
local PATTERNS = {
  { pattern = "<SHORT%-NAME>([^<]+)</SHORT%-NAME>",  hl = "ArxmlShortName" },
  { pattern = "<CATEGORY>([^<]+)</CATEGORY>",        hl = "ArxmlCategory" },
  { pattern = '<[A-Z%-]+%-REF[^>]*>([^<]+)</[A-Z%-]+%-REF>', hl = "ArxmlRef" },
}

local function highlight_buffer(buf)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  for lnum, line in ipairs(lines) do
    for _, entry in ipairs(PATTERNS) do
      local s = 0
      while true do
        local ms, me, capture = line:find(entry.pattern, s + 1)
        if not ms then break end
        -- highlight only the captured value, not the tags
        local tag_before = line:sub(ms, me - #capture - (line:sub(me - #capture + 1, me):match("</") and 2 or 1))
        local val_start = ms + (line:sub(ms, me):find(">") or 1)
        local val_end = val_start + #capture - 2
        -- Simpler: find the inner text col positions
        local inner_start = line:find(">", ms)
        if inner_start then
          inner_start = inner_start  -- 1-indexed col of '>'
          local inner_end = inner_start + #capture - 1
          vim.api.nvim_buf_add_highlight(buf, ns, entry.hl, lnum - 1, inner_start, inner_end)
        end
        s = me
      end
    end
  end
end

function M.setup()
  define_highlights()

  local group = vim.api.nvim_create_augroup("ArxmlHighlight", { clear = true })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "TextChanged", "TextChangedI" }, {
    group = group,
    pattern = "*.arxml",
    callback = function(ev)
      -- Debounce via deferred call to avoid highlighting on every keystroke
      vim.defer_fn(function()
        if vim.api.nvim_buf_is_valid(ev.buf) then
          highlight_buffer(ev.buf)
        end
      end, 150)
    end,
  })

  -- Re-define highlights on colorscheme change
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = define_highlights,
  })
end

return M
