---@meta
error('this file should not be required directly')

---@alias buftype ''|'acwrite'|'help'|'nofile'|'nowrite'|'quickfix'|'terminal'|'prompt'

-- _G.nv = require('nvim.util')
_G.nv.fn = require('nvim.util.fn')

--- what junegunn/vim-plug returns as `g:plugs`
---@class vimPlugSpec
---@field uri string Git URL of the plugin repository.
---@field dir string Local directory where the plugin is installed.
---@field frozen integer Whether the plugin is frozen (0 or 1).
---@field branch string Branch name if specified.

---@alias PluginTable table<string, vimPlugSpec>
-- vim.g.plugs = vim.g.plugs or {}
