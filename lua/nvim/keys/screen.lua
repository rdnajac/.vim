return {
  'NStefan002/screenkey.nvim',
  ---@type screenkey.config
  opts = {
    win_opts = {
      border = 'rounded',
      title = {
        { ' Sc', 'DiagnosticOk' },
        { 're', 'DiagnosticWarn' },
        { 'en', 'DiagnosticInfo' },
        { 'key ', 'DiagnosticError' },
      },
    },
    hl_groups = {
      ['screenkey.hl.key'] = { link = 'Chromatophore' },
      ['screenkey.hl.map'] = { link = 'Chromatophore' },
      ['screenkey.hl.sep'] = { link = 'Normal' },
    },
    compress_after = 3,
    clear_after = 3,
    emit_events = true,
    disable = {
      filetypes = {},
      buftypes = {},
      modes = {},
    },
    show_leader = false,
    group_mappings = false,
    display_infront = {},
    display_behind = {},
    -- filter = function(keys)
    --   local screenkey = require('screenkey')
    --   for i, k in ipairs(keys) do
    --     if screenkey.statusline_component_is_active() and k.key == '%' then
    --       keys[i].key = '%%'
    --     end
    --   end
    --   return keys
    -- end,
    colorize = function(keys) return keys end,
    separator = '',
    keys = {
      -- ['%'] = '%%',
      ['<Tab>'] = '󰌒 ',
      ['<Cr>'] = '󰌑 ',
      -- ['<Esc>'] = '󱊷 ',
      -- ['<Space>'] = '␣',
      ['<BS>'] = '󰁮 ',
      -- ['CTRL'] = 'C-',
      -- ['ALT'] = 'M-',
      -- ['<leader>'] = '<leader>',
      ['<Left>'] = ' ',
      ['<Right>'] = ' ',
      ['<Up>'] = ' ',
      ['<Down>'] = ' ',
      -- TEST: this
      ['<PAGEUP>'] = 'PgUp',
      ['<PAGEDOWN>'] = 'PgDn',
      ['<INSERT>'] = 'Ins',
      ['<DEL>'] = 'Del',
      ['<HOME>'] = 'Home',
      ['<END>'] = 'End',
    },
    notify_method = 'echo',
    log = {
      -- min_level = 0,
      filepath = vim.fn.stdpath('data') .. '/screenkey.log',
    },
  },
  toggles = {
    ['<leader>uk'] = {
      name = 'Screenkey floating window',
      get = function() return require('screenkey').is_active() end,
      set = function() return require('screenkey').toggle() end,
    },
    ['<leader>uK'] = {
      name = 'Screenkey statusline component',
      get = function() return require('screenkey').statusline_component_is_active() end,
      set = function() return require('screenkey').toggle_statusline_component() end,
    },
  },
}
