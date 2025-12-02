_G.t = { vim.uv.hrtime() }

vim.loader.enable()
require('nvim.util.track')

---@diagnostic disable-next-line: duplicate-set-field
function vim.print(...)
  return vim._print(true, ...)
end

vim.g.stdpath = vim.iter({ 'cache', 'config', 'data', 'state' }):fold({}, function(stdpath, d)
  stdpath[d] = vim.fn.stdpath(d)
  return stdpath
end)

vim.g.plug_home = vim.fs.joinpath(vim.g.stdpath.data, 'site', 'pack', 'core', 'opt')
vim.g.loaded_netrw = false

if vim.env.PROF then
  vim.opt.rtp:append(vim.fs.joinpath(vim.g.plug_home, 'snacks.nvim'))
  require('snacks.profiler').startup({
    -- startup = { event = 'UIEnter' },
  })
end

vim.cmd.runtime('vimrc')

local vim_plugins = vim.islist(vim.g.plugs) and vim.g.plugs -- TODO: check if they are in url form
  or vim.tbl_map(function(plug)
    return plug.uri -- if it's a dict, it's probably from `vim-plug`
  end, vim.tbl_values(vim.g.plugs or {}))

local Plug = require('nvim.util.plug')
vim.pack.add(vim_plugins, {
  ---@param plug_data { spec: vim.pack.Spec, path: string }
  load = function(plug_data)
    local spec = plug_data.spec
    local name = spec.name
    -- TODO: load wrapper
    vim.cmd.packadd({ args = { name }, bang = true, magic = { file = false } })
    if vim.endswith(name, '.nvim') then
      local modname = name:gsub('.nvim', '')
      Plug(require('nvim.' .. modname)):setup()
    end
  end,
})

require('nvim')
