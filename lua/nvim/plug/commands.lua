vim.api.nvim_create_user_command('Plug', function(args)
  assert(type(args.fargs) == 'table', 'Plug command requires a table argument')
  vim.pack.add(args.fargs)
end, { nargs = '*', force = true })

vim.api.nvim_create_user_command('PackUpdate', function(opts)
  vim.pack.update({ force = opts.bang })
end, { bang = true })
