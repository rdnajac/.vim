-- assumes input is [a-z],_
local function to_camel_case(str)
  return str:gsub('_(%a)', function(c) return c:upper() end):gsub('^%l', string.upper)
end

local cmds = vim
  .iter(vim.tbl_keys(Snacks.picker))
  :filter(function(name) return vim.is_callable(Snacks.picker[name]) end)
  :filter(
    function(name)
      return not vim.list_contains({ 'get', 'health', 'keymap', 'lazy', 'select', 'setup' }, name)
    end
  )
  :map(function(name) return name, to_camel_case(name) end)
  :filter(function(name, cmd) return vim.fn.exists(':' .. cmd) ~= 2 end)
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
