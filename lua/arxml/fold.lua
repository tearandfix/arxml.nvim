local M = {}

function M.foldexpr(lnum)
    local line = vim.fn.getline(lnum)

    -- opening tag (not self-closing)
    if line:match("^%s*<[^/!?][^>]->?$") 
      and not line:match("/>%s*$") 
      and not line:match("<AR%-PACKAGES")
      and not line:match("<ELEMENTS") then
        return "a1"
    end

    -- closing tag
    if line:match("^%s*</[^>]+>")
      and not line:match("</AR%-PACKAGES")
      and not line:match("</ELEMENTS") then
        return "s1"
    end

    return "="
end

function M.foldtext()
    local start = vim.v.foldstart
    local finish = vim.v.foldend

    local first_line = vim.fn.getline(start)
    local tag = first_line:match("<([^%s>/]+)") or "element"

    local line = vim.fn.getline(start+1)
    local short_name = line:match("<SHORT%-NAME>(.-)</SHORT%-NAME>")

    local lines = finish - start + 1

    if short_name then
        return string.format("%d  %s: %s", lines, tag, short_name)
    else
        return string.format("%d  %s", lines, tag)
    end
end

return M
