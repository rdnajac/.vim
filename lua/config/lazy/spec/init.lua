local lazyopts = require('config.lazy.opts')

if vim.env.LAZY == '1' then
  vim.g.autoformat = false
  vim.g.lazyvim_picker = 'snacks'
  vim.g.lazyvim_cmp = 'blink.cmp'
else
  vim.g.lazyvim_check_order = false
  vim.opt.rtp:append(vim.fn.stdpath('data') .. '/lazy/LazyVim/')
  _G.LazyVim = require('lazyvim.util')
  print('/…/lazy/spec/init.lua: 11 lazyvim live')
  LazyVim.plugin.lazy_file()
end

-- HACK: skip loading `LazyVim` options
-- package.loaded['lazyvim.config.options'] = true

return {
  'LazyVim/LazyVim',
  {
    'LazyVim/LazyVim',
    opts = lazyopts,
  },
  { import = 'lazyvim.plugins', cond = vim.env.LAZY == '1' },
  { import = 'lazyvim.plugins.coding', cond = vim.env.LAZY ~= '1' },
}
