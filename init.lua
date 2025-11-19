_G.t = { vim.uv.hrtime() }

vim.loader.enable()
require('nvim.util.track')

--- @diagnostic disable-next-line: duplicate-set-field
function vim.print(...)
  return vim._print(true, ...)
end

-- vim.g.stdpath = vim.tbl_map(function(d)
--   return { [d] = vim.fn.stdpath(d) }
-- end, { 'cache', 'config', 'data', 'state' })
local stdpath_dict = {}
vim.tbl_map(function(d)
  stdpath_dict[d] = vim.fn.stdpath(d)
end, { 'cache', 'config', 'data', 'state' })
vim.g.stdpath = stdpath_dict
vim.g.plug_home = vim.fs.joinpath(vim.g.stdpath.data, 'site', 'pack', 'core', 'opt')
vim.g.loaded_netrw = false

if vim.env.PROF then
  vim.opt.rtp:append(vim.fs.joinpath(vim.g.plug_home, 'snacks.nvim'))
  ---@type snacks.profiler.Config
  local opts = {
    -- startup = { event = 'UIEnter' },
  }
  require('snacks.profiler').startup(opts)
end

--- loads vim settings and exports vim.g.plugins
vim.cmd([[
  runtime vimrc
  let s:me = resolve(expand('<sfile>:p'))
  " echom s:me
]])

-- the rest if the owl
require('nvim').init()
vim.api.nvim_create_user_command('Hardcopy', function()
  local file = vim.api.nvim_buf_get_name(0)
  -- local commandstring = ([[vim -Nu NONE -c "e %s | hardcopy | qa!"]]):format(file)
  local commandstring = ([[vim -Nu NONE -es -c "e %s" -c "hardcopy" -c "qa!"]]):format(file)
  local cmd = vim.split(commandstring, ' ')

  vim.system(cmd)
  local obj = vim.system(cmd):wait()
  dd(obj)
end, {})
