local M = {}

M.specs = {
  'nvim-treesitter/nvim-treesitter',
  'nvim-treesitter/nvim-treesitter-textobjects',
}

-- M.build = 'TSUpdate'
M.build = function()
  local parsers = require('nvim.treesitter.parsers')
  require('nvim-treesitter').install(parsers)
end

local aug = vim.api.nvim_create_augroup('treesitter', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sh', 'markdown', 'r', 'rmd', 'python' },
  group = aug,
  callback = function()
    vim.treesitter.start()
  end,
  desc = 'Start treesitter for certiain file types',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'kitty', 'ghostty', 'zsh' },
  group = aug,
  callback = function(ev)
    vim.treesitter.language.register('bash', ev.match)
    vim.treesitter.start(0, 'bash')
  end,
  desc = 'Force some file types to use `bash` treesitter',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'quarto' },
  group = aug,
  callback = function(ev)
    -- vim.treesitter.language.register('rmarkdown', ev.match)
    -- vim.treesitter.start()
    -- vim.treesitter.start(0, 'rmd')
  end,
  desc = 'Force some file types to use `bash` treesitter',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'kitty', 'ghostty', 'ghostty.chezmoitmpl' },
  group = aug,
  command = 'setlocal commentstring=#\\ %s',
  desc = 'Set the commentstring for languages that use `#`',
})

--- Check if the current node is a comment node
---@return boolean
M.in_comment_node = function()
  local success, node = pcall(vim.treesitter.get_node)
  return success
      and node
      and vim.tbl_contains({
        'comment',
        'line_comment',
        'block_comment',
        'comment_content',
      }, node:type())
    or false
end

-- stylua: ignore start
vim.keymap.set('n', '<C-Space>', function() require('nvim.treesitter.selection').start() end, { desc = 'Start selection' })
vim.keymap.set('x', '<C-Space>', function() require('nvim.treesitter.selection').increment() end, { desc = 'Increment selection' })
vim.keymap.set('x', '<BS>', function() require('nvim.treesitter.selection').decrement() end, { desc = 'Decrement selection' })
vim.keymap.set('n', '<leader>uI', function() vim.treesitter.inspect_tree(); vim.api.nvim_input('I') end, { desc = 'Inspect Tree' })
-- stylua: ignore end

Snacks.toggle.treesitter():map('<leader>ut')

require('nvim.treesitter.mycommentparser')

return M
