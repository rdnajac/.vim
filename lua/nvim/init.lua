local M = {}

-- _G.nv = vim
--   .iter(vim.fn.readdir(vim.fn.stdpath('config') .. '/lua/nvim'))
--   :map(function(fname) return vim.fn.fnamemodify(fname, ':r') end)
--   :map(function(mname) return mname, require('nvim.' .. mname) end)
--   :fold({}, rawset) -- inits an empty table and maps `nv[nvim.k] = v`

M.ui = require('nvim.ui')
M.keys = require('nvim.keys')
M.mini = require('nvim.mini')
M.lsp = require('nvim.lsp')
M.treesitter = require('nvim.treesitter')

local status = M.ui.status
M.statusline = status.line
M.winbar = function()
  if vim.bo.filetype == 'snacks_dashboard' then
    return ''
  end
  if vim.api.nvim_get_current_win() ~= tonumber(vim.g.actual_curwin) then
    return status.buffer()
  end
  local a = status.buffer
  local b = status.lsp
  local c = status.treesitter
  return status.render(a(), b(), ' ' .. c()) .. '%#WinBar# '
end

return M
