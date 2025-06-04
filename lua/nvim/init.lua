if vim.env.PROF then
  vim.opt.rtp:append(vim.fn.stdpath('data') .. '/lazy/snacks.nvim')
  ---@diagnostic disable-next-line: missing-fields
  require('snacks.profiler').startup({})
end

-- bootstrap lazy.nvim
require('nvim.lazy')

-- autocmds can be loaded lazily when not opening a file
local lazy_autocmds = vim.fn.argc(-1) == 0
if not lazy_autocmds then
  require('nvim.config.autocmds')
end

-- load settings after `VeryLazy`
vim.api.nvim_create_autocmd('User', {
  group = vim.api.nvim_create_augroup('LazyVim', { clear = true }),
  pattern = 'VeryLazy',
  callback = function()
    if lazy_autocmds then
      require('nvim.config.autocmds')
    end
    require('nvim.config.keymaps')
    require('nvim.config.options')
    require('munchies')
    -- vim.cmd([[color tokyonight]])
  end,
})

