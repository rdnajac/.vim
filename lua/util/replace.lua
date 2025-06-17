local M = {}

local function escape(text)
  return text:gsub('([/\\])', '\\%1')
end

function M.selection()
  vim.cmd('normal! gv"xy')
  local sel = vim.fn.getreg('x')

  if not sel or sel == '' then
    vim.notify('No selection found', vim.log.levels.WARN)
    return
  end

  vim.ui.input({ prompt = 'Replace all instances of "' .. sel .. '" with: ' }, function(rep)
    if rep and rep ~= '' then
      local search = escape(sel)
      local replacement = escape(rep)
      local cmd = string.format('%%s/%s/%s/g', search, replacement)
      vim.cmd(cmd)
    end
  end)
end

return M
