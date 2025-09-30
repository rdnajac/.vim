--- @meta
error('this file should not be required directly')

nv.blink = require('nvim.blink')
nv.lsp = require('nvim.lsp')
nv.mini = require('nvim.mini')
nv.oil = require('nvim.oil')
nv.plug = require('nvim.plug')
nv.snacks = require('nvim.snacks')
nv.treesitter = require('nvim.treesitter')
nv.ui = require('nvim.ui')
nv.util = require('nvim.util')
nv.copilot = require('nvim.copilot')
nv.diagnostic = require('nvim.diagnostic')
nv.dial = require('nvim.dial')
nv.icon = require('nvim.icon')
nv.flash = require('nvim.flash')
nv.mason = require('nvim.lsp.mason')
nv.md = require('nvim.render-markdown')
nv.notify = require('nvim.notify')
nv.oil = require('nvim.oil')
nv.r = require('nvim.r')
nv.todo = require('nvim.todo-comments')
nv.tokyonight = require('nvim.tokyonight')
nv.wk = require('nvim.which-key')

-- from: `LazyVim/lua/lazyvim/types.lua`
---@class vim.api.create_autocmd.callback.args
---@field id number
---@field event string
---@field group number?
---@field match string
---@field buf number
---@field file string
---@field data any

---@class vim.api.keyset.create_autocmd.opts: vim.api.keyset.create_autocmd
---@field callback? fun(ev:vim.api.create_autocmd.callback.args):boolean?

--- @param event any (string|array) Event(s) that will trigger the handler
--- @param opts vim.api.keyset.create_autocmd.opts
--- @return integer
function vim.api.nvim_create_autocmd(event, opts) end
