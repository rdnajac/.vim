local haxx = vim.api.nvim_create_augroup('haxx', { clear = true })

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
      vim.o.laststatus = 0
    end
  end,
})

vim.api.nvim_create_autocmd('CmdlineEnter', {
  group = haxx,
  command = 'set laststatus=0',
})
