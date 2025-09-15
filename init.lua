-- init.lua
-- vim._print(true, vim.tbl_keys(package.loaded))
_G.t0 = vim.uv.hrtime() -- capture the start time

vim.loader.enable()

--- @type table
_G.nv = require('nvim') or {}
-- TODO: get this to work with luals

-- vim.notify = nv.notify
--
-- _G.info = function(...)
--   vim.notify(vim.inspect(...), vim.log.levels.INFO)
-- end

vim.cmd([[runtime vimrc]])
vim.cmd([[packadd vimline.nvim]])

_G.bt = Snacks.debug.backtrace

for _, mod in ipairs({ 'copilot', 'lsp', 'treesitter' }) do
  nv.plug(vim.tbl_map(nv.plug.spec, require('nvim.' .. mod).specs))
end

require('nvim.config')
require('nvim.util.startup')
vim.print = Snacks.notify
