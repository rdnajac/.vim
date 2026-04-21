--- init.lua
T1 = vim.uv.hrtime()
vim.loader.enable()
_G.pp = vim.print

require('nvim.ui.2')

vim.cmd([[colorscheme tokyonight]])
vim.cmd([[source ~/.vim/vimrc]])

require('snacks')

_G.dd = Snacks.debug
_G.bt = dd.backtrace
_G.nv = vim
  .iter(vim.fn.readdir(vim.fn.stdpath('config') .. '/lua/nvim'))
  :map(function(fname) return vim.fn.fnamemodify(fname, ':r') end)
  :map(function(mname) return mname, require('nvim.' .. mname) end)
  :fold({}, rawset) -- inits an empty table and maps `nv[nvim.k] = v`

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
  nv.blink,
  nv.keys.which,
  -- { 'stevearc/conform.nvim', opts = {} },
  -- { 'stevearc/quicker.nvim', opts = {} },
  {
    'stevearc/oil.nvim',
    enabled = false,
    opts = {},
    keys = { { '-', '<Cmd>Oil<CR>' } },
  },
  {
    'folke/sidekick.nvim',
    opts = function()
      vim.schedule(vim.lsp.inline_completion.enable)
      vim.cmd([[
        nnoremap <expr> <Tab> v:lua.require'sidekick'.nes_jump_or_apply() ? '' : '<Tab>'
        nnoremap <leader>ap <Cmd>lua require('sidekick.cli').prompt({ name = 'copilot' })<CR>
        nnoremap <leader>at <Cmd>lua require('sidekick.cli').send({ name = 'copilot', msg = '{file}' })<CR>
        xnoremap <leader>at <Cmd>lua require('sidekick.cli').send({ name = 'copilot', msg = '{this}' })<CR>
      ]])
      -- stylua: ignore
      vim.keymap.set({'n','t','i','x'}, '<C-.>', function() require('sidekick.cli').focus('copilot') end, {})
      return {}
    end,
    toggle = {
      ['<leader>uN'] = {
        name = 'Sidekick NES',
        get = function() return require('sidekick.nes').enabled end,
        set = function(state) require('sidekick.nes').enable(state) end,
      },
    },
  },
  -- {
  --   'folke/flash.nvim',
  --   ---@type Flash.Config
  --   opts = {},
  --   keys = function()
  --     local flash = require('flash')
  --     -- stylua: ignore
  --     return {
  --       { { 'o', 'x', 'n' }, '<C-J>', flash.jump,  {} },
  --       { { 'o', 'x', 'n' }, '<C-F>', flash.treesitter, {} },
  --       { { 'o', 'x' }, 'R',     flash.treesitter_search, {} },
  --       { { 'o' },      'r',     flash.remote,     {} },
  --       { { 'c' },      '<C-F>', flash.toggle,     {} },
  --     }
  --   end,
  -- },
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

-- lazy load treesitter plugins when not opening a file
if vim.fn.argc(-1) == 0 then
  Plug(nv.treesitter.specs)
else
  vim.schedule(function() Plug(nv.treesitter.specs) end)
end

require('mason').setup()
