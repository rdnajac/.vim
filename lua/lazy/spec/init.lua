require('lazy.file')

return {
  {
    'folke/tokyonight.nvim',
    -- dev = true,
  },
  {
    'LazyVim/LazyVim',
    priority = 9999,
    -- HACK: override the default LazyVim config entirely
    config = function()
      _G.LazyVim = require('lazyvim.util')
      LazyVim.config = require('lazy.config')
      -- LazyVim.track('colorscheme')
      require('tokyonight').load(require('nvim.ui.tokyonight'))
      -- LazyVim.track()
      -- LazyVim.on_very_lazy(function()
      --   LazyVim.format.setup()
      --   LazyVim.root.setup()
      -- end)
    end,
  },
  {
    'folke/which-key.nvim',
    opts = {
      keys = { scroll_down = '<C-j>', scroll_up = '<C-k>' },
      preset = 'helix',
      show_help = false,
      sort = { 'order', 'alphanum', 'case', 'mod' },
      -- triggers = { { ',', mode = { 'i' } } },
      -- triggers = { { '<leader>', mode = { 'n', 'v' } }, },
      spec = {
        {
          {
            mode = { 'n', 'v' },
            { '[', group = 'prev' },
            { ']', group = 'next' },
            { 'g', group = 'goto' },
            { 'z', group = 'fold' },
          },
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

          -- groups
          { 'co', group = 'comment below' },
          { 'cO', group = 'comment above' },

          { '<leader>dp', group = 'profiler' },
          -- { '<localleader>l', group = 'vimtex' },

          -- descriptions
          { 'gx', desc = 'Open with system app' },
        },
        { hidden = true, { 'g~' }, { 'g#' }, { 'g*' } },
        {
          mode = { 'i' },
          { ',', group = 'completion' },
          { ',o', '<C-x><C-o>', desc = 'Omni completion' },
          { ',f', '<C-x><C-f>', desc = 'File name completion' },
          { ',i', '<C-x><C-i>', desc = 'Keyword completion from current and included files' },
          { ',l', '<C-x><C-l>', desc = 'Line completion' },
          { ',n', '<C-x><C-n>', desc = 'Keyword completion from current file' },
          { ',t', '<C-x><C-]>', desc = 'Tag completion' },
          { ',u', '<C-x><C-u>', desc = 'User-defined completion' },
        },
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
    keys = {
      {
        ']t',
        function()
          require('todo-comments').jump_next()
        end,
        desc = 'Next Todo Comment',
      },
      {
        '[t',
        function()
          require('todo-comments').jump_prtv()
        end,
        desc = 'Previous Todo Comment',
      },
      {
        '<leader>st',
        function()
          Snacks.picker.todo_comments()
        end,
        desc = 'Todo',
      },
      {
        '<leader>sT',
        function()
          Snacks.picker.todo_comments({ keywords = { 'TODO', 'FIX', 'FIXME' } })
        end,
        desc = 'Todo/Fix/Fixme',
      },
    },
  },
  {
    'github/copilot.vim',
    cmd = 'Copilot',
    event = 'BufWinEnter',
    init = function()
      vim.deprecate = function() end -- HACK: remove this once plugin is updated
      -- vim.g.copilot_no_maps = true
      vim.g.copilot_workspace_folders = { '~/GitHub', '~/.local/share/chezmoi/' }

      vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
      })
      vim.g.copilot_no_tab_map = true
    end,
    -- config = function()
    --   -- Block the normal Copilot suggestions
    --   vim.api.nvim_create_augroup('github_copilot', { clear = true })
    --   vim.api.nvim_create_autocmd({ 'FileType', 'BufUnload' }, {
    --     group = 'github_copilot',
    --     callback = function(args)
    --       vim.fn['copilot#On' .. args.event]()
    --     end,
    --   })
    --   vim.fn['copilot#OnFileType']()
    -- end,
  },
  { 'nvim-lua/plenary.nvim', lazy = true },
}
-- vim:fdl=1
