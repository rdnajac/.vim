local aug = vim.api.nvim_create_augroup('treesitter', {})

--- @param ft string|string[] filetype or list of filetypes
--- @param override string|nil optional override parser lang
local autostart = function(ft, override)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = ft,
    group = aug,
    callback = function(args)
      vim.treesitter.start(args.buf, override)
    end,
    desc = 'Automatically start tree-sitter with optional language override',
  })
end

-- TODO: ensure installed
-- TODO: autocmd to check if the ft is installed and start if not blacklisted
local autostart_filetypes = {
  'markdown',
  'python',
  'yaml',
  'json',
  'html',
  'css',
  'javascript',
  'typescript',
  'toml',
  'vim',
}

autostart(autostart_filetypes)
autostart({ 'sh', 'zsh' }, 'bash')
-- TODO: use register

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
