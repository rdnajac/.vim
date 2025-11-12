---@class nv
---@field util any
---@field config any
---@field plugins any
---@field plug fun(plugin: string|table): any
---@field specs vim.pack.Spec[]
---@field stats fun(): { hits: number, misses: number }
---@field winbar fun(): string
_G.nv = {}

-- TODO: these should be generated automatically...
nv.config = require('nvim.config')
nv.dirvish = require('nvim.dirvish')
nv.fn = require('nvim.util.fn')
nv.icons = require('nvim.icons')
nv.icons.fs = require('nvim.icons.fs')
nv.icons.mini = require('nvim.icons.mini')
nv.lazy = require('nvim.lazy')
nv.lsp = require('nvim.lsp')
nv.plugins = require('nvim.plugins')
nv.snacks = require('nvim.snacks')
nv.status = require('nvim.util.status')
nv.tokyonight = require('nvim.tokyonight')
nv.treesitter = require('nvim.treesitter')
nv.util = require('nvim.util')
