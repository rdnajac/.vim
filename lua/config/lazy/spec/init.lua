local lazyopts = require('config.lazy.opts')
local lazy = vim.env.LAZY

if lazy == '1' then
  print('zzz')
  vim.g.autoformat = false
  vim.g.lazyvim_picker = 'snacks'
  vim.g.lazyvim_cmp = 'blink.cmp'
else
  vim.g.lazyvim_check_order = false
  vim.opt.rtp:append(vim.fn.stdpath('data') .. '/lazy/LazyVim/')
  if lazy == '0' then
    print('hacks')
    local M = require('lazyvim.config')
    M.setup(lazyopts)
    M.init()
  else
    _G.LazyVim = require('lazyvim.util')
  end
  LazyVim.plugin.lazy_file()
end

-- HACK: skip loading `LazyVim` options
package.loaded['lazyvim.config.options'] = true

return {
  'LazyVim/LazyVim',
  {
    'LazyVim/LazyVim',
    opts = lazyopts,
    enabled = lazy ~= '0', -- true for nil or '1'; false for '0' (hack mode)
  },
  { import = 'lazyvim.plugins', cond = vim.env.LAZY == '1' },
  { import = 'lazyvim.plugins.coding', cond = vim.env.LAZY ~= '1' },
}
