require('lazy.file')

return {
  {
    'LazyVim/LazyVim',
    priority = 9999,
    -- HACK: override the default LazyVim config entirely
    config = function()
      _G.LazyVim = require('lazyvim.util')
      LazyVim.config = require('lazy.config')
      -- LazyVim.track('colorscheme')
      require('tokyonight').load()
      -- LazyVim.track()
      -- LazyVim.on_very_lazy(function()
      --   LazyVim.format.setup()
      --   LazyVim.root.setup()
      -- end)
    end,
  },
  {
    'folke/which-key.nvim',
    ---@class wk_opts
    opts = {
      defer = function(_)
        return
      end,
      keys = { scroll_down = '<C-j>', scroll_up = '<C-k>' },
      preset = 'helix',
      show_help = false,
      sort = { 'order', 'alphanum', 'case', 'mod' },
  triggers = {
    { '<leader>', mode = { 'n', 'v' } },
  },
      spec = {
        {
          -- {
          --   mode = { 'n', 'v' },
          --   { '[', group = 'prev' },
          --   { ']', group = 'next' },
          --   { 'g', group = 'goto' },
          --   { 'z', group = 'fold' },
          -- },

          mode = { 'n' },
          {
            '<leader>b',
            group = 'buffer',
            expand = function()
              return require('which-key.extras').expand.buf()
            end,
          },
          {
            '<c-w>',
            group = 'windows',
            expand = function()
              return require('which-key.extras').expand.win()
            end,
          },

          { '<leader>x', group = 'diagnostics/quickfix', icon = { icon = '󱖫 ', color = 'green' } },
          {
            icon = { icon = ' ', color = 'green' },
            { '<leader>E' },
            { '<leader>c', group = 'code' },
            { '<leader>i' },
            { '<leader>m' },
            { '<leader>t' },
            { '<leader>v', group = 'vimrc' },
            { '<leader>w' },
            { '<leader>ft', desc = 'filetype plugin' },
            { '<leader>fs', desc = 'filetype snippets' },
          },
          {
            icon = { icon = '󰢱 ', color = 'blue' },
            { '<leader>fT', desc = 'filetype plugin (.lua)' },
          },
          -- better descriptions
          -- { '<localleader>l', group = 'vimtex' },
          { 'gx', desc = 'Open with system app' },
        },
        { hidden = true, { 'g~' }, { 'g#' }, { 'g*' } },
      },
    },
  },
  -- §: todo-comments
  -- Section:
  {
    'folke/todo-comments.nvim',
    event = 'LazyFile',
    opts = {
      keywords = {
        Section = {
          icon = '§ ',
          color = 'info',
          -- alt = '§',
        },
      },
    },
    -- stylua: ignore
    keys = {
      { ']t', function() require('todo-comments').jump_next() end, desc = 'Next Todo Comment', },
      { '[t', function() require('todo-comments').jump_prtv() end, desc = 'Previous Todo Comment', },
      { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
      { "<leader>sT", function () Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
    },
  },
  {
    'github/copilot.vim',
    cmd = 'Copilot',
    event = 'BufWinEnter',
    init = function()
      vim.g.copilot_no_maps = true
      vim.deprecate = function() end -- HACK: remove this once plugin is updated
    end,
    config = function()
      -- Block the normal Copilot suggestions
      vim.api.nvim_create_augroup('github_copilot', { clear = true })
      vim.api.nvim_create_autocmd({ 'FileType', 'BufUnload' }, {
        group = 'github_copilot',
        callback = function(args)
          vim.fn['copilot#On' .. args.event]()
        end,
      })
      vim.fn['copilot#OnFileType']()
    end,
  },
  {
    'nvim-lua/plenary.nvim',
    lazy = true,
  },
  -- TODO: copy this
  { import = 'lazyvim.plugins.extras.util.mini-hipatterns' },
}
