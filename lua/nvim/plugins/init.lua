local me = debug.getinfo(1, 'S').source:sub(2)
local dir = vim.fn.fnamemodify(me, ':p:h')
local files = vim.fn.globpath(dir, '*', false, true)

local M = {}

M.spec = vim
  .iter(files)
  :filter(function(f) return f ~= me end)
  :map(dofile)
  :map(function(t) return vim.islist(t) and t or { t } end)
  :fold({}, function(acc, v) return vim.list_extend(acc, v) end)

return M
