vim.loader.enable()

local debug = require('nvim.util.debug')
_G.bt = require('nvim.util.debug').bt
_G.dd = require('nvim.util.debug').dd
_G.pp = require('nvim.util.debug').pp

if vim.env.PROF then
  local plug_home = vim.g.plug_home or '/Users/rdn/.local/share/nvim/site/pack/core/opt'
  local snacks = plug_home .. '/snacks.nvim'
  vim.opt.rtp:append(snacks)

  ---@type snacks.profiler.Config
  local opts = {
    thresholds = {
      time = { 1, 10 },
      pct = { 1, 20 },
      count = { 1, 100 },
      ---@type table<string, snacks.profiler.Pick|fun():snacks.profiler.Pick?>
      presets = {
        startup = { min_time = 0.1, sort = false },
        on_stop = {},
        filter_by_plugin = function()
          return { filter = { def_plugin = vim.fn.input('Filter by plugin: ') } }
        end,
      },
    },
  }
  require('snacks.profiler').startup(opts)
end

vim.cmd.runtime('vimrc')
-- if vim.env.LAZY then return require('nvim.lazy').bootstrap() end
if vim.g.myplugins ~= nil then
  vim.pack.add(vim.g.myplugins)
end

vim.o.cmdheight = 0
vim.o.winborder = 'rounded'

require('vim._extui').enable({})

require('folke.snacks')
require('folke.tokyonight')
require('folke.which-key')

_G.nv = {
  blink = require('nvim.blink'),
  lazy = require('nvim.lazy'),
  lsp = require('nvim.lsp'),
  treesitter = require('nvim.treesitter'),
}

-- TODO: register notify setup
-- TODO: register debug setup
setmetatable(nv, {
  -- new index that just oprints wjen a module is required
  __newindex = function(t, k, v)
    print('set: ' .. k)
    rawset(t, k, v)
  end,
  __index = function(t, k)
    -- vim.schedule(function()
    --   print('access: ' .. k)
    -- end)
    t[k] = require('nvim.util.' .. k)
    return rawget(t, k)
  end,
})

local plugins = require('nvim.plugins')
local iter = vim.iter(plugins)
local specs = iter
  :map(function(p)
    return nv.plug(p):tospec()
  end)
  :totable()

-- if vim.v.vim_did_enter == 1 then return end

vim.pack.add(specs, {
  ---@param plug_data {spec: vim.pack.Spec, path: string}
  load = function(plug_data)
    local spec = plug_data.spec
    vim.cmd.packadd({ spec.name, bang = true, magic = { file = false } })
    if spec.data and vim.is_callable(spec.data.setup) then
      spec.data.setup()
    end
  end,
})

return M
