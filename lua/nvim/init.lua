local M = {}

-- _G.nv = vim
--   .iter(vim.fn.readdir(vim.fn.stdpath('config') .. '/lua/nvim'))
--   :map(function(fname) return vim.fn.fnamemodify(fname, ':r') end)
--   :map(function(mname) return mname, require('nvim.' .. mname) end)
--   :fold({}, rawset) -- inits an empty table and maps `nv[nvim.k] = v`

M.ui = require('nvim.ui')
M.keys = require('nvim.keys')
M.mini = require('nvim.mini')
M.diagnostics = require('nvim.diagnostics')
M.lsp = require('nvim.lsp')
M.treesitter = require('nvim.treesitter')

return M
