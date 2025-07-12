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
  end,
})

local sel = require('nvim.treesitter.selection')
vim.keymap.set('n', '<C-Space>', sel.start, { desc = 'Start selection' })
vim.keymap.set('x', '<C-Space>', sel.increment, { desc = 'Increment selection' })
vim.keymap.set('x', '<BS>', sel.decrement, { desc = 'Decrement selection' })

require('nvim-treesitter').install(require('nvim.treesitter.parsers'))

require('ts-comments').setup({})
