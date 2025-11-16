Snacks.picker.scriptnames = function()
  require('nvim.snacks.picker.scriptnames')
end

-- assumes input is [a-z],_
local function to_camel_case(str)
  return str
    :gsub('_(%a)', function(c)
      return c:upper()
    end)
    :gsub('^%l', string.upper)
end

vim
  .iter(vim.tbl_keys(Snacks.picker))
  :filter(function(name)
    return not vim.list_contains({
      'config',
      'get',
      'highlight',
      'keymap',
      'lazy',
      'meta',
      'setup',
    }, name)
  end)
  :each(function(name)
    local cmd = to_camel_case(name)
    -- currently, this only guards against `:Man`
    if vim.fn.exists(':' .. cmd) ~= 2 then
      vim.api.nvim_create_user_command(cmd, function(args)
        local opts = {}
        if nv.fn.is_nonempty_string(args.args) then
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
