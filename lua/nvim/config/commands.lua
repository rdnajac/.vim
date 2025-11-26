if not Snacks then
  print('no snacks?')
  return
end
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

-- local pickers
--
-- Snacks.picker.pickers({
--   enter = false,
--   live = false,
--   show_empty = true,
--   on_show = function(p)
--     return p:close()
--   end,
--   on_close = function(p)
--     pickers = vim.tbl_map(function(m)
--       return m.text
--     end, p:items())
--   end,
-- })
local cmds = {}

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
      'select',
      'util',
    }, name)
  end)
  :each(function(name)
    local cmd = to_camel_case(name)
    cmds[#cmds + 1] = cmd
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

-- dd(require('snacks.picker.source.meta').pickers())

vim.api.nvim_create_user_command('Hardcopy', function()
  local file = vim.api.nvim_buf_get_name(0)
  -- local commandstring = ([[vim -Nu NONE -c "e %s | hardcopy | qa!"]]):format(file)
  local commandstring = ([[vim -Nu NONE -es -c "e %s" -c "hardcopy" -c "qa!"]]):format(file)
  local cmd = vim.split(commandstring, ' ')

  vim.system(cmd)
  local obj = vim.system(cmd):wait()
  dd(obj)
end, {})
