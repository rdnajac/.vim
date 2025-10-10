local register_commands = function()
  local command = vim.api.nvim_create_user_command

  -- plug commands
  command('PlugUpdate', function(opts)
    local plugs = #opts.fargs > 0 and opts.fargs or nil
    vim.pack.update(plugs, { force = opts.bang })
  end, {
    nargs = '*',
    bang = true,
    complete = function()
      return vim.tbl_map(function(p)
        return p.spec.name
      end, vim.pack.get())
    end,
  })
  command('PlugStatus', function(opts)
    local plugin = nv.is_nonempty_string(opts.fargs) and opts.fargs or nil
    vim._print(true, vim.pack.get(plugin, { info = opts.bang }))
  end, {
    bang = true,
    nargs = '*',
    complete = function()
      return vim.tbl_map(function(p)
        return p.spec.name
      end, vim.pack.get())
    end,
  })
  command('Plugins', function()
    local active, inactive = {}, {}
    for _, p in ipairs(vim.pack.get()) do
      if p.active then
        table.insert(active, p.spec.name)
      else
        table.insert(inactive, p.spec.name)
      end
    end
    print(
      string.format(
        'Plugins: %d total (%d active, %d inactive)',
        #active + #inactive,
        #active,
        #inactive
      )
    )
    print('\nActive:\n' .. table.concat(active, '\n'))
    print('\nInactive:\n' .. table.concat(inactive, '\n'))
  end, {})

  local unloaded = require('nvim.plugins').unloaded()

  command('PlugClean', function(opts)
    local plugs = #opts.fargs > 0 and opts.fargs or unloaded
    vim.pack.del(plugs)
  end, {
    nargs = '*',
    complete = function(_, _, _)
      return unloaded
    end,
  })

  -- snacks commands
  -- assumes input is [a-z],_
  local function to_camel_case(str)
    return str
      :gsub('_(%a)', function(c)
        return c:upper()
      end)
      :gsub('^%l', string.upper)
  end

  -- add any additional methods to skip creating commands for
  local blacklist = {
    'config',
    'highlight',
    'keymap',
    'meta',
    'setup',
  }
  -- also skip the lazy picker if we're not using lazy.nvim
  if not package.loaded['lazy'] then
    blacklist[#blacklist + 1] = 'lazy'
  end

  vim
    .iter(vim.tbl_keys(Snacks.picker))
    :filter(function(name)
      return not vim.list_contains(blacklist, name)
    end)
    :each(function(name)
      local cmd = to_camel_case(name)
      -- currently, this only guards against `:Man`
      if vim.fn.exists(':' .. cmd) ~= 2 then
        vim.api.nvim_create_user_command(cmd, function(args)
          local opts = {}
          if nv.is_nonempty_string(args.args) then
            --- @diagnostic disable-next-line: param-type-mismatch
            local ok, result = pcall(loadstring('return {' .. args.args .. '}'))
            if ok and type(result) == 'table' then
              opts = result
            end
          end
          Snacks.picker[name](opts)
        end, { nargs = '?', desc = 'Snacks Picker: ' .. cmd })
      end
    end)
end

return {
  setup = function()
    nv.lazyload(function()
      register_commands()
    end, 'CmdLineEnter')
  end,
}
