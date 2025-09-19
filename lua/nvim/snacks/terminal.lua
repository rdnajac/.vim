vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('lazygit', { clear = true }),
  -- pattern = 'term://*/lazygit',
  -- pattern = 'snacks_terminal',
  callback = function(args)
    -- if vim.endswith(vim.api.nvim_buf_get_name(args.buf), 'lazygit') then
    vim.schedule(function()
      vim.cmd.startinsert()
    end)
    -- end
  end,
  desc = 'Start insertmode when entering a Snacks.lazygit buffer',
})
