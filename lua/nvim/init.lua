if vim.env.PROF then
  vim.opt.rtp:append(vim.fn.stdpath('data') .. '/lazy/snacks.nvim')
  ---@class snacks.profiler.Config
  ---@diagnostic disable-next-line: missing-fields
  require('snacks.profiler').startup({
    startup = {
      -- event = 'VeryLazy',
      -- event = 'UIEnter',
    },
    presets = { startup = { min_time = 0, sort = false } },
  })
end

--require('nvim.colorscheme').init()
-- bootstrap lazy.nvim and LazyVim
require('config.lazy').load({
  profiling = {
    loader = false,
    require = false,
  },
})

--- load settings **after** `VeryLazy` event
vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    local lazy_val = vim.env.LAZY
    if lazy_val == nil then
      print('lazy=nil')
      require('config.autocmds')
      require('config.keymaps')
      require('config.options')
    elseif lazy_val == '0' then
      print('not lazy')
    else
      print('lazy')
    end
    require('nvim.diagnostic')
    require('nvim.lsp')
    require('munchies')
    vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
    vim.opt.foldexpr = 'v:lua.LazyVim.ui.foldexpr()'
  end,
})
