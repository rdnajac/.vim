vim.api.nvim_create_user_command('Plug', function(args)
  assert(type(args.fargs) == 'table', 'Plug command requires a table argument')
  vim.pack.add(args.fargs)
end, { nargs = '*', force = true })
