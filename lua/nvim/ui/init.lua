-- make our these settings load before `UIEnter`

if vim.fn.argc(-1) == 0 then
  vim.opt.winborder = 'none'
  vim.opt.laststatus = 0
  -- TODO: once?
  vim.api.nvim_create_autocmd('User', {
    pattern = 'SnacksDashboardOpened',
    callback = function()
      vim.opt.laststatus = 0
      vim.opt.winborder = 'rounded'
    end,
  })
else
  vim.opt.winborder = 'rounded'
  vim.opt.laststatus = 3
end

vim.opt.cmdheight = 0

local nvim_ui = vim.api.nvim_create_augroup('nvim_ui', { clear = true })
vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = nvim_ui,
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
  group = nvim_ui,
  command = 'set laststatus=0',
})

require('nvim.ui.chromatophore') -- XXX: experimental!
require('vim._extui').enable({}) -- XXX: experimental!
