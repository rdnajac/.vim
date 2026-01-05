vim.loader.enable()
vim.o.cmdheight = 0
vim.o.winborder = 'rounded'
require('vim._extui').enable({})

local debug_util = require('nvim.util.debug')
_G.bt = debug_util.bt
_G.dd = debug_util.dd
_G.pp = debug_util.pp

if vim.env.PROF then
  require('folke.snacks.profiler')
end

local plugins = {}

vim.api.nvim_create_user_command('Plug', function(opts)
  table.insert(plugins, 'https://github.com/' .. opts.args:gsub([[']], '') .. '.git')
end, { nargs = 1 })

vim.cmd.runtime('vimrc')

vim.pack.add(plugins)

require('folke.snacks')
require('folke.tokyonight').colorscheme()
-- vim.cmd.colorscheme('tokyomidnight')
require('folke.which-key')

_G.nv = require('nvim')

local specs = vim
  .iter(nv.plugins)
  :map(function(p)
    return nv.plug(p):tospec()
  end)
  :totable()

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
