local haxx = vim.api.nvim_create_augroup('haxx', { clear = true })

vim.opt.cmdheight = 0
vim.opt.winborder = 'rounded'

-- HACK: don't show lualine on dashboard
if vim.fn.argc(-1) == 0 then
  vim.opt.winborder = 'none'
  -- if vim.bo.filetype == 'snacks_dashboard' then
  --   vim.opt.laststatus = 0
  -- end
end

vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = haxx,
  callback = function(args)
    if vim.bo[args.buf].filetype ~= 'snacks_dashboard' then
      vim.api.nvim_create_autocmd('CmdlineLeave', {
        once = true,
        callback = function()
          vim.o.laststatus = 3
        end,
      })
      -- vim.o.laststatus = 0
    end
  end,
})

vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = haxx,
  command = 'set laststatus=0',
})

vim.api.nvim_create_autocmd('User', {
  pattern = 'SnacksDashboardOpened',
  callback = function(ev)
    vim.opt.winborder = 'rounded'
  end,
})
require('lazy.spec.ui.lualine.theme')
require('vim._extui').enable({}) -- XXX: experimental!
