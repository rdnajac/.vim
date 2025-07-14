local M = { 'nvim-treesitter/nvim-treesitter' }

M.dependencies = {
  'folke/ts-comments.nvim',
}

local aug = vim.api.nvim_create_augroup('treesitter', { clear = true })
local filetypes = { 'vim', 'sh', 'tex', 'markdown', 'python' }

vim.api.nvim_create_autocmd('FileType', {
  group = aug,
  pattern = filetypes,
  callback = function()
    vim.treesitter.start()
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'kitty', 'ghostty', 'zsh' },
  group = aug,
  callback = function(ev)
    vim.treesitter.language.register('bash', ev.match)
    vim.treesitter.start(0, 'bash')
    vim.cmd([[setlocal commentstring=#\ %s]])
  end,
})

local sel = require('nvim.plugins.treesitter.selection')
vim.keymap.set('n', '<C-Space>', sel.start, { desc = 'Start selection' })
vim.keymap.set('x', '<C-Space>', sel.increment, { desc = 'Increment selection' })
vim.keymap.set('x', '<BS>', sel.decrement, { desc = 'Decrement selection' })

M.config = function()
  -- also set up dependencies
  require('ts-comments').setup({})

  vim.api.nvim_create_autocmd('User', {
    pattern = 'TSUpdate',
    group = aug,
    callback = function()
      -- Use custom parser that highlights strings in `backticks` in comments
      require('nvim-treesitter.parsers').comment = {
        install_info = {
          url = 'https://github.com/rdnajac/tree-sitter-comment',
          generate = true,
          queries = 'queries/neovim',
        },
      }
      require('nvim-treesitter').install(require('nvim.plugins.treesitter.parsers'))
    end,
  })
end

return M
