Snacks.picker.scriptnames = function() require('snacks.picker.scriptnames') end

vim.cmd([[ command! LazyGit :lua Snacks.lazygit() ]])

-- assumes input is [a-z],_
local function to_camel_case(str)
  return str:gsub('_(%a)', function(c) return c:upper() end):gsub('^%l', string.upper)
end

local cmds = {}

vim.schedule(function()
  -- TODO: work on this...
  require('folke.snacks.toggles')
  -- TODO: make commands when making keymaps
  vim
    .iter(vim.tbl_keys(Snacks.picker))
    :filter(
      function(name)
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
      end
    )
    :each(function(name)
      local cmd = to_camel_case(name)
      cmds[#cmds + 1] = cmd
      -- currently, this only guards against `:Man`
      if vim.fn.exists(':' .. cmd) ~= 2 then
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
      end
    end)
end)
