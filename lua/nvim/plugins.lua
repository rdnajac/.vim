return {
  {
    'folke/flash.nvim',
    ---@type Flash.Config
    opts = {},
    keys = function()
      local flash = require('flash')
      return {
        { { 'n' }, 'F', flash.jump, {} },
        { { 'o', 'x', 'n' }, '<C-J>', flash.jump, {} },
        { { 'o', 'x' }, '<C-F>', flash.treesitter, {} },
        { { 'o', 'x' }, 'R', flash.treesitter_search, {} },
        { { 'o' }, 'r', flash.remote, {} },
        { { 'c' }, '<C-F>', flash.toggle, {} },
      }
    end,
  },
  {
    'hat0uma/csvview.nvim',
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      parser = { comments = { '#', '//' } },
      keymaps = {
        -- FIXME: conflicts with treesitter function
        textobject_field_inner = { 'iF', mode = { 'o', 'x' } },
        textobject_field_outer = { 'aF', mode = { 'o', 'x' } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { '<Tab>', mode = { 'n', 'v' } },
        jump_prev_field_end = { '<S-Tab>', mode = { 'n', 'v' } },
        jump_next_row = { '<Enter>', mode = { 'n', 'v' } },
        jump_prev_row = { '<S-Enter>', mode = { 'n', 'v' } },
      },
    },
    toggle = {
      ['<leader>cv'] = {
        name = 'csvView',
        get = function() require('csvview').is_enabled(0) end,
        set = function() require('csvview').toggle() end,
      },
    },
  },
}
