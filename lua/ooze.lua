local M = {}

-- Define custom global flags with built-in toggles using Snacks Toggle
-- stylua: ignore
local _create_flags = function()
  local flag = require('snacks.toggle').flag
  flag({ name = 'ooze_auto_advance',  mapping = '~A',    desc = 'Toggle Auto Advance',       label = 'Auto Advance (Line Feed)', })
  flag({ name = 'ooze_auto_scroll',   mapping = '~s',    desc = 'Toggle Auto Scroll',        label = 'Auto Scroll',              })
  flag({ name = 'ooze_send_on_enter', mapping = '~<CR>', desc = 'Toggle Send on Enter',      label = 'Send Line',                })
  flag({ name = 'ooze_auto_exec',     mapping = '~x',    desc = 'Toggle Auto Execute',       label = 'Auto Execute',             })
  flag({ name = 'ooze_skip_comments', mapping = '~k',    desc = 'Toggle Auto Skip Comments', label = 'Skip Comments',            })
end

-- Use `var` to get the value of the (buffer > global > default) variable
local CR = function()
  if Snacks.util.var(0, 'ooze_send_on_enter', 0) == 1 then
    vim.cmd('call ooze#sendline()')
    vim.cmd('call ooze#linefeed()')
    return ''
  else
    return '<CR>'
  end
end

M.setup = function()
  _create_flags()
  vim.api.nvim_create_user_command('CR', CR, {})
  vim.keymap.set('n', '<CR>', '<Cmd>CR<CR>', { silent = true })
  vim.keymap.set('v', '<CR>', '<Cmd>OozeVisual<CR>', { silent = true })
  vim.api.nvim_create_user_command('RunFile', function()
    vim.cmd('call ooze#runfile()')
  end, {})
  vim.keymap.set('n', ',<CR>', '<Cmd>RunFile<CR>', { silent = true })
  require('ooze.autocmds')
  -- require('ooze.keymaps')
end

return M
