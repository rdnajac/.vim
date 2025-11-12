return {
  -- TODO: try statusline component
  'NStefan002/screenkey.nvim',
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
    filter = function(keys)
      return keys
    end,
    colorize = function(keys)
      return keys
    end,
    separator = '',
    keys = {
      ['<TAB>'] = '󰌒',
      ['<CR>'] = '󰌑',
      ['<ESC>'] = '󱊷 ',
      -- ['<SPACE>'] = '␣',
      ['<BS>'] = '󰁮',
      ['<DEL>'] = 'Del',
      ['<HOME>'] = 'Home',
      ['<END>'] = 'End',
      ['<PAGEUP>'] = 'PgUp',
      ['<PAGEDOWN>'] = 'PgDn',
      ['<INSERT>'] = 'Ins',
      ['CTRL'] = 'C-',
      ['ALT'] = 'M-',
      ['<leader>'] = '<leader>',
    },
    notify_method = 'echo',
    log = {
      min_level = vim.log.levels.OFF,
      filepath = vim.fn.stdpath('data') .. '/screenkey_log',
    },
  },
  -- after = function()
    -- vim.cmd.Screenkey()
  -- end,
}
