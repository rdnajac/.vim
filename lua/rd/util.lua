local api = vim.api
local fn = vim.fn

local M = {}

--- Run a Vim command and return the output as a list of lines
---
--- @param vimcommand string Vim command to execute
--- @return string[] output
M.exec = function(vimcommand)
  return vim.split(api.nvim_exec2(vimcommand, { output = true }).output, '\n', { trimempty = true })
end

--- Get all lines from a buffer as a list of strings
---
--- @param bufnr integer? buffer number, defaults to current buffer
--- @return string[] lines
M.get_buf_lines = function(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  local nlines = api.nvim_buf_line_count(bufnr)
  return api.nvim_buf_get_lines(bufnr, 0, nlines, false)
end

-- https://github.com/neovim/neovim/discussions/38271#discussion-9630986
M.get_visual = function()
  local vis_mode = fn.mode():match('[Vv\22]')
  if not vis_mode then
    return
  end
  local line_regs = fn.getregionpos(fn.getpos('v'), fn.getpos('.'), {
    type = vis_mode,
    eol = true,
    exclusive = false,
  })
  local sel_text = {}
  for _, reg in ipairs(line_regs) do
    local r1, c1, r2, c2 = reg[1][2], reg[1][3], reg[2][2], reg[2][3]
    local buf_text = vim.api.nvim_buf_get_text(0, r1 - 1, c1 - 1, r2 - 1, c2, {})
    vim.list_extend(sel_text, buf_text)
  end
  return sel_text, line_regs
end

return M
