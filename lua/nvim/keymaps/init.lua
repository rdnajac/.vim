local me = debug.getinfo(1, 'S').source:sub(2)
local dir = vim.fn.fnamemodify(me, ':p:h')
local files = vim.fn.globpath(dir, '*', false, true)

local M = {}

M.spec = {
  {
    -- see icon rules at ~/.local/share/nvim/site/pack/core/opt/which-key.nvim/lua/which-key/icons.lua
    'folke/which-key.nvim',
    config = function()
      local wk = require('which-key')
      wk.setup({
        keys = { scroll_down = '<C-j>', scroll_up = '<C-k>' },
        preset = 'helix',
        replace = {
          desc = {
            -- { '<Plug>%(?(.*)%)?', '%1' },
            { '^%+', '' },
            { '<[cC]md>', ':' },
            { '<[cC][rR]>', '󰌑 ' },
            { '<[sS]ilent>', '' },
            { '^lua%s+', '' },
            { '^call%s+', '' },
            -- { '^:%s*', '' },
          },
        },
        show_help = false,
        sort = { 'order', 'alphanum', 'case', 'mod' },
        spec = {
          '<leader>?',
          function() wk.show({ global = false }) end,
          desc = 'Buffer Keymaps (which-key)',
        },
        {
          '<C-w><Space>',
          function() wk.show({ keys = '<C-w>', loop = true }) end,
          desc = 'Window Hydra Mode (which-key)',
        },
        -- triggers = { { '<auto>', mode = 'nixsotc' } },
      })
      -- add a field at runtime?
      -- M.register = wk.add
    end,
  },
  -- vim.g.screenkey = ---@type "statusline"|"window"|
  -- vim.schedule(function() require('screenkey').toggle_statusline_component() end)
  -- BUG: what's going on with `which-key` doubling keys pressed?
  {
    'NStefan002/screenkey.nvim',
    enabled = false,
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
    toggles = function()
      local screenkey = require('screenkey')
      return {
        ['<leader>uR'] = {
          name = 'Screenkey statusline component',
          -- get = screenkey.is_active,
          get = screenkey.statusline_component_is_active,
          -- set = screenkey.toggle,
          set = screenkey.toggle_statusline_component,
        },
      }
    end,
  },
}

return M
