-- Define custom global flags with built-in toggles using Snacks Toggle
-- Function to define toggleable vim global variables using Snacks.toggle
-- @param opts table containing:
--   name: variable name without 'g:' prefix
--   default: default value (0 or 1)
--   mapping: key mapping string (e.g. '<localleader>ta')
--   desc: description for the mapping (optional)
-- @return the Snacks toggle object
local flag = function(opts)
  local name = opts.name
  local default = opts.default or 1
  local mapping = opts.mapping
  local desc = opts.desc or ('Toggle ' .. name)

  -- Define the variable if it doesn't exist
  vim.cmd(string.format([[ if !exists('g:%s') | let g:%s = %s | endif ]], name, name, default))

  local toggle = Snacks.toggle({
    name = opts.label or name:gsub('_', ' '):gsub('^%l', string.upper),
    get = function()
      -- Convert Vim's '0'/'1' string to boolean
      return vim.g[name] == '1' or vim.g[name] == 1
    end,
    set = function(state)
      vim.g[name] = state and '1' or '0'
    end,
  })

  if mapping then
    toggle:map(mapping, { desc = desc })
  end

  require('which-key').add({ 'mapping', desc = 'Toggle ' .. name })

  return toggle
end

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
