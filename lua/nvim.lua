-- nvim/init.lua
if vim.env.PROF then
  vim.opt.rtp:append(vim.fn.stdpath('data') .. '/lazy/snacks.nvim')
  ---@diagnostic disable-next-line: missing-fields
  require('snacks.profiler').startup({})
end

require('config.lazy').load({
  profiling = {
    loader = false,
    require = true,
  },
})

--- load settings after `VeryLazy` event
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require('munchies')
  end,
})
