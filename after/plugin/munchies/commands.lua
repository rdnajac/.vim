local dir_completion = function(arglead, cmdline, cursorpos)
  local matches = vim.fn.getcompletion(arglead, 'dir')
  if #matches == 0 then
    return { vim.fn.getcwd() }
  end
  return matches
end

local command = vim.api.nvim_create_user_command

command('Config', function()
  Snacks.picker.files({ 
    cwd = vim.fn.stdpath('config'),
    ft = { 'lua', 'vim' } 
  })
end, {})

vim.api.nvim_create_user_command('Zoxide', function(_)
  Snacks.picker.zoxide({
    confirm = 'edit',
    -- confirm = function(picker, item)
    --   picker.cd()
    --   picker:close()
    -- end,
  })
end, { desc = 'Zoxide to cd or edit (!)' })

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
  })
end, {
  nargs = '*',
  complete = dir_completion,
})

command('Keymaps', function()
  local opts = {
    confirm = function(picker, item)
      picker:close()
      -- TODO: use vsplit-drop
      vim.cmd('edit ' .. item.file)
    end,
    layout = { preset = 'mylayout' },
  }
  Snacks.picker.keymaps(opts)
end, {})

command('Commands', function()
  local opts = {
    confirm = function(picker, item)
      picker:close()
      if item.command then
        local sid = item.command.script_id
        if sid and sid ~= 0 then
          local src
          for line in vim.fn.execute('scriptnames'):gmatch('[^\r\n]+') do
            local id, path = line:match('^%s*(%d+):%s+(.+)$')
            if tonumber(id) == sid then
              src = path
              break
            end
          end
          if src then
            vim.cmd('edit ' .. src)
            vim.fn.search('\\<' .. item.cmd .. '\\>', 'w')
          end
        end
      end
    end,
  }
  Snacks.picker.commands(opts)
end, {})

command('Chezmoi', function()
  local chezmoi_dir = vim.g.chezmoi_dir or '~/.local/share/chezmoi'
  -- vim.cmd(('Files -h %s'):format(chezmoi_dir))
  Snacks.picker.files({
    cwd = chezmoi_dir,
    hidden = true,
    ignore = true,
    title = 'ChezMoi',
  })
end, {})

command('Scratch', function(opts)
  if opts.bang then
    Snacks.scratch.select()
  else
    Snacks.scratch()
  end
end, { bang = true })

-- Snacks.picker.grep({ dirs = vim.api.nvim_list_runtime_paths() })
