vim.api.nvim_create_user_command('GitBlameLine', function()
  local line_number = vim.fn.line('.')
  local filename = vim.api.nvim_buf_get_name(0)
  print(vim.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }):wait().stdout)
end, { desc = 'Print the git blame for the current line' })

snacks_commands = function()
  --- assumes input is [a-z],_
  local function to_camel_case(str)
    return str
      :gsub('_(%a)', function(c)
        return c:upper()
      end)
      :gsub('^%l', string.upper)
  end

  -- add any additional methods to skip creating commands for
  vim.list_extend(skip, { 'config', 'highlight', 'keymap' })
  -- also skip the lazy picker if we're not using lazy.nvim
  if not package.loaded['lazy'] then
    skip[#skip + 1] = 'lazy'
  end

  vim
    .iter(vim.tbl_keys(Snacks.picker))
    :filter(function(name)
      return not vim.list_contains(skip, name)
    end)
    :each(function(name)
      local cmd = to_camel_case(name)
      -- currently, this only guards against `:Man`
      if vim.fn.exists(':' .. cmd) ~= 2 then
        vim.api.nvim_create_user_command(cmd, function(args)
          local opts = {}
          if nv.util.is_nonempty_string(args.args) then
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
