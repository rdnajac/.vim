local cmds = vim
  .iter(vim.tbl_keys(Snacks.picker))
  -- remove non-callable keys and internal methods
  :filter(
    function(name) return vim.is_callable(Snacks.picker[name]) end
  )
  :filter(
    function(name)
      return not vim.list_contains({ 'get', 'health', 'keymap', 'lazy', 'select', 'setup' }, name)
    end
  )
  -- assumes input is [a-z],_
  :map(function(name) return name, nv.camelCase(name) end)
  -- skips `Man`
  :filter(function(name, cmd)
    local exists = vim.fn.exists(':' .. cmd) == 2
    if exists then
      print(name .. ' command (:' .. cmd .. ') already exists')
    end
    return not exists
  end)
  :map(function(name, cmd)
    vim.api.nvim_create_user_command(cmd, function(args)
      local opts = {}
      if nv.is_nonempty_string(args.args) then
        ---@diagnostic disable-next-line: param-type-mismatch
        local ok, result = pcall(loadstring('return {' .. args.args .. '}'))
        if ok and type(result) == 'table' then
          opts = result
        end
      end
      Snacks.picker[name](opts)
    end, { nargs = '?', desc = 'Snacks Picker: ' .. cmd })
    return name
  end)
  :totable()

return cmds
