local dir_completion = function(arglead, cmdline, cursorpos)
  local matches = vim.fn.getcompletion(arglead, 'dir')
  if #matches == 0 then
    return { vim.fn.getcwd() }
  end
  return matches
end

local command = vim.api.nvim_create_user_command

vim.api.nvim_create_user_command('Files', function(opts)
  local args = vim.tbl_filter(function(arg)
    return arg ~= ''
  end, vim.split(opts.args or '', '%s+'))
  local cwd, flags = nil, {}
  for _, arg in ipairs(args) do
    if arg:sub(1, 1) == '-' then
      flags.hidden = arg:find('h') and true or flags.hidden
      flags.ignore = arg:find('i') and true or flags.ignore
    elseif not cwd then
      cwd = arg
    end
  end
  cwd = cwd or vim.fn.getcwd()
  Snacks.picker.files({
    cwd = cwd,
    hidden = flags.hidden,
    ignore = flags.ignore,
    title = '  [ ' .. cwd .. ' ]',
  })
end, {
  nargs = '*',
  complete = dir_completion,
})

command('Chezmoi', function()
  local chezmoi_dir = vim.g.chezmoi_dir or '~/.local/share/chezmoi'
  vim.cmd(('Files -h %s'):format(chezmoi_dir))
end, {})

command('Plugins', function(opts)
  local opts_tbl = { bang = opts.bang }
  require('munchies.picker.plugins').files(opts_tbl)
end, { bang = true, nargs = '*', complete = 'file' })

command('PluginsGrep', function(opts)
  local opts_tbl = { bang = opts.bang }
  require('munchies.picker.plugins').grep(opts_tbl)
end, { bang = true, nargs = '*', complete = 'file' })

command('Scratch', function(opts)
  if opts.bang then
    Snacks.scratch.select()
  else
    Snacks.scratch()
  end
end, { bang = true })

command('Zoxide', function(opts)
  require('munchies.picker.zoxide').pick(opts.bang and '!' or '')
end, { bang = true })

command('Autocmds', function()
  Snacks.picker.autocmds()
end, {})

command('Commands', function()
  Snacks.picker.commands()
end, {})

command('Config', function()
  Snacks.picker.files({ cwd = vim.fn.stdpath('config') })
end, {})

command('Explorer', function()
  Snacks.picker.explorer()
end, {})

command('Help', function()
  Snacks.picker.help()
end, {})

command('Highlights', function()
  Snacks.picker.highlights()
end, {})

command('Scripts', function()
  require('munchies.picker.scriptnames')()
end, {})

command('Terminal', function()
  Snacks.terminal.toggle()
end, {})

command('Keymaps', function()
  Snacks.picker.keymaps()
end, {})

command('Lazygit', function()
  Snacks.Lazygit()
end, {})
