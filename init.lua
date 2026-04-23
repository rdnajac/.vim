--- init.lua
T1 = vim.uv.hrtime()
vim.loader.enable()
_G.pp = vim.print

vim.cmd([[colorscheme tokyonight]])
vim.cmd([[source ~/.vim/vimrc]])

require('snacks')
_G.dd = Snacks.debug
_G.bt = dd.backtrace
Snacks.setup({
  dashboard = {
    sections = {
      { section = 'header' },
      { icon = '󰱼 ', title = 'Files', { section = 'recent_files', indent = 2 } },
      { icon = ' ', desc = 'Health ', key = 'H', action = ':checkhealth' },
      { icon = '󰒲 ', desc = 'LazyGit', key = 'G', action = ':lua Snacks.lazygit()' },
      { icon = ' ', desc = 'Mason  ', key = 'M', action = ':Mason' },
      { icon = ' ', desc = 'News   ', key = 'N', action = ':News' },
      { icon = ' ', desc = 'Update ', key = 'U', action = ':lua vim.pack.update()' },
      {
        section = 'terminal',
        cmd = ('cowsay "%s"|sed "s/^/        /"'):format(
          "The computing scientist's main challenge is not to get confused by the complexities of his own making"
        ),
        padding = 1,
      },
      { footer = tostring(vim.version()) },
    },
  },
  explorer = { replace_netrw = true, trash = true },
  image = { enabled = true },
  indent = { indent = { only_current = false, only_scope = true } },
  input = { enabled = true },
  quickfile = { enabled = true },
  picker = require('munchies').picker,
  scope = { enabled = true },
  scroll = { enabled = true },
  words = { enabled = true },
})

Plug({
  require('nvim.keys.which'),
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
    enabled = true,
    init = function()
      Snacks.keymap.set('n', 'yu', function()
        local word = vim.fn.expand('<cword>')
        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        -- copy the <cword> to a new line below the current line
        vim.api.nvim_buf_set_lines(0, row, row, true, { word })
        -- move cursor to the new line
        vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
        -- execute <Plug>RInsertLineOutput from normal mode
        vim.api.nvim_feedkeys(vim.keycode('<Plug>RInsertLineOutput'), 'n', false)
        -- delete the line with the word
        vim.api.nvim_buf_set_lines(0, row, row + 1, true, {})
        -- move cursor back to original position
        vim.api.nvim_win_set_cursor(0, { row, col })
      end, { desc = 'Debug/Print (R)', ft = { 'r', 'rmd', 'quarto' } })

      require('r').setup({
        R_args = { '--quiet', '--no-save' },
        -- user_maps_only = true,
        -- quarto_chunk_hl = { highlight = false },
        Rout_more_colors = true,
        hook = {
          after_R_start = function() vim.notify('R started!') end,
          -- after_ob_open = function() vim.notify('Object Browser') end,
        },
      })
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
})

require('mason').setup()
_G.nv = require('nvim')
