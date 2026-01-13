---@meta
error('this file should not be required directly')

---@alias buftype ''|'acwrite'|'help'|'nofile'|'nowrite'|'quickfix'|'terminal'|'prompt'

nv.blink = require('nvim.blink')
nv.keys = require('nvim.keymaps')
nv.lsp = require('nvim.lsp')
nv.mini = require('nvim.mini')
nv.ts = require('nvim.treesitter')
nv.plugins = require('nvim.plugins')

nv.debug = require('nvim.util.debug')
nv.echoserver = require('nvim.util.echoserver')
nv.exec = require('nvim.util.exec')
nv.external = require('nvim.util.external')
nv.file = require('nvim.util.file')
nv.formatter = require('nvim.util.formatter')
nv.gen = require('nvim.util.gen')
nv.git = require('nvim.util.git')
nv.icons = require('nvim.util.icons')
nv.json = require('nvim.util.json')
nv.mason = require('nvim.util.mason')
nv.module = require('nvim.util.module')
nv.munchies = require('nvim.util.munchies')
nv.notify = require('nvim.util.notify')
nv.patch = require('nvim.util.patch')
nv.path = require('nvim.util.path')
nv.plug = require('plug')
nv.root = require('nvim.util.root')
nv.snippets = require('nvim.util.snippets')
nv.status = require('nvim.util.status')
nv.submodules = require('nvim.util.submodules')
nv.tmuxline = require('nvim.util.tmuxline')
nv.track = require('nvim.util.track')
nv.wget = require('nvim.util.wget')

--- what junegunn/vim-plug returns as `g:plugs`
---@class vimPlugSpec
---@field uri string Git URL of the plugin repository.
---@field dir string Local directory where the plugin is installed.
---@field frozen integer Whether the plugin is frozen (0 or 1).
---@field branch string Branch name if specified.
