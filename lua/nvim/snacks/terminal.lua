vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('snacks_terminal', { clear = true }),
  callback = function(args)
    if vim.bo.filetype == 'snacks_terminal' and
     vim.endswith(vim.api.nvim_buf_get_name(args.buf), 'lazygit') then
      vim.cmd.startinsert()
    end
  end,
  desc = 'Start insertmode when entering a Snacks.lazugit buffer'
})
