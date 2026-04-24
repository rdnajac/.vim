return {
  -- { 'stevearc/conform.nvim', opts = {} },
  -- { 'stevearc/quicker.nvim', opts = {} },
  {
    'stevearc/oil.nvim',
    enabled = false,
    opts = {},
    keys = { { '-', '<Cmd>Oil<CR>' } },
  },
  {
    'Saghen/blink.cmp',
    build = 'BlinkCmp build',
    opts = require('opts.blink'),
  },
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
    'R-nvim/R.nvim',
    init = function()
      ---@type RConfigUserOpts
      local opts = {
        R_args = { '--quiet', '--no-save' },
        -- user_maps_only = true,
        -- quarto_chunk_hl = { highlight = false },
        Rout_more_colors = true,
        hook = {
          on_filetype = function()
            vim.keymap.set('n', 'yu', function()
              local row, col = unpack(vim.api.nvim_win_get_cursor(0))
              -- copy the <cword> to a new line below the current line
              vim.api.nvim_buf_set_lines(0, row, row, true, {  vim.fn.expand('<cword>') })
              -- move cursor to the new line
              vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
              -- execute <Plug>RInsertLineOutput from normal mode
              vim.api.nvim_feedkeys(vim.keycode('<Plug>RInsertLineOutput'), 'n', false)
              -- delete the line with the word
              vim.api.nvim_buf_set_lines(0, row, row + 1, true, {})
              -- move cursor back to original position
              vim.api.nvim_win_set_cursor(0, { row, col })
            end, { desc = 'Debug/Print (R)', buf = 0 })
          end,
          after_R_start = function() vim.notify('R started!') end,
          after_ob_open = function() vim.notify('Object Browser opened!') end,
        },
      }
      require('r').setup(opts)
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
