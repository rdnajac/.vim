vim.api.nvim_create_autocmd("User", {
  pattern = "SnacksDashboardOpened",
  once    = true,
  callback = function()
    vim.opt.winborder = "rounded"
  end,
})
