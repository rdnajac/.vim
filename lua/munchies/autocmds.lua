vim.api.nvim_create_autocmd('FileType', {
  pattern = 'snacks_dashboard',
  callback = function()
    local old_winborder = vim.o.winborder
    if old_winborder ~= 'none' then
      vim.o.winborder = 'none'
      vim.api.nvim_create_autocmd('User', {
        pattern = 'SnacksDashboardClosed',
        callback = function()
          vim.o.winborder = old_winborder
        end,
        once = true,
      })
      vim.opt.lazyredraw = true
      vim.schedule(function()
        Snacks.dashboard.update()
        vim.opt.lazyredraw = false
      end)
    end
  end,
})
