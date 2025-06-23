-- Define custom global flags with built-in toggles using Snacks Toggle
local flag = require('munchies.toggle').flag
flag({
  name = 'ooze_auto_advance',
  mapping = 'yoa',
  desc = 'Toggle Auto Advance',
  label = 'Auto Advance (Line Feed)',
})
flag({
  name = 'ooze_auto_scroll',
  mapping = 'yos',
  desc = 'Toggle Auto Scroll',
  label = 'Auto Scroll',
})
flag({
  name = 'ooze_send_on_enter',
  mapping = 'yo<CR>',
  desc = 'Toggle Send on Enter',
  label = 'Send Line',
  0,
})
flag({
  name = 'ooze_auto_exec',
  mapping = 'yox',
  desc = 'Toggle Auto Execute',
  label = 'Auto Execute',
})
flag({
  name = 'ooze_skip_comments',
  mapping = 'yok',
  desc = 'Toggle Auto Skip Comments',
  label = 'Skip Comments',
})

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

return M
