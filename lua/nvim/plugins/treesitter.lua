vim.treesitter.language.register('bash', 'zsh')

local aug = vim.api.nvim_create_augroup('treesitter', {})

-- TODO: ensure installed
local autostart_filetypes = {
  'css',
  'html',
  'javascript',
  'json',
  'markdown',
  'python',
  'sh',
  'toml',
  'typescript',
  'vim',
  'yaml',
  'zsh',
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = autostart_filetypes,
  group = aug,
  callback = function(ev)
    vim.treesitter.start(ev.buf)
  end,
  desc = 'Automatically start tree-sitter',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'r', 'rmd', 'quarto' },
  group = aug,
  command = 'setlocal foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()',
  desc = 'Use treesitter folding for select filetypes',
})

local M = {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = vim.cmd.TSUpdate,
    keys = {
      { '<C-Space>', nv.treesitter.selection.start },
      { mode = 'x', '<C-Space>', nv.treesitter.selection.increment },
      { mode = 'x', '<BS>', nv.treesitter.selection.decrement },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    enabled = false,
    opts = {
      move = { set_jumps = true },
      select = {
        lookahead = true,
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V', -- linewise
          ['@class.outer'] = '<c-v>', -- blockwise
        },
        include_surrounding_whitespace = false,
      },
    },
    -- after = function()
    --   local moves =
    --     goto_next_start = {
    --       [']f'] = '@function.outer',
    --       [']c'] = '@class.outer',
    --       [']a'] = '@parameter.inner',
    --     },
    --     goto_next_end = {
    --       [']F'] = '@function.outer',
    --       [']C'] = '@class.outer',
    --       [']A'] = '@parameter.inner',
    --     },
    --     goto_previous_start = {
    --       ['[f'] = '@function.outer',
    --       ['[c'] = '@class.outer',
    --       ['[a'] = '@parameter.inner',
    --     },
    --     goto_previous_end = {
    --       ['[F'] = '@function.outer',
    --       ['[C'] = '@class.outer',
    --       ['[A'] = '@parameter.inner',
    --     },
    --   }
  },
  { 'nvim-treesitter/nvim-treesitter-context' },
}

return M
