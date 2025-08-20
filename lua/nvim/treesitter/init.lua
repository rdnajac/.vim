local M = { 'nvim-treesitter/nvim-treesitter' }

M.version = 'main'

M.dependencies = {
  {
    src = 'nvim-treesitter/nvim-treesitter-textobjects',
    version = M.version,
  },
}

-- FIXME: TSUpdate is not available until after setup is called
M.build = function()
  Snacks.util.on_module('nvim-treesitter', function()
    ddd('Updating nvim-treesitter...')
    vim.cmd('TSUpdate')
  end)
end

local aug = vim.api.nvim_create_augroup('treesitter', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sh', 'tex', 'markdown', 'python', 'vim' },
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
  pattern = { 'kitty', 'ghostty', 'ghostty.chezmoitmpl' },
  group = aug,
  callback = function()
    vim.cmd([[setlocal commentstring=#\ %s]])
  end,
  desc = 'Set the commentstring for languages that use `#`',
})

---@diagnostic disable-next-line: param-type-mismatch
vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  group = aug,
  callback = function()
    require('nvim-treesitter.parsers').comment = {
      install_info = {
        url = 'https://github.com/rdnajac/tree-sitter-comment',
        generate = true,
        queries = 'queries/neovim',
      },
    }
  end,
  desc = 'Install custom parser that highlights strings in `backticks` in comments',
})

M.install_parsers = function()
  local parsers = require('nvim.treesitter.parsers')
  require('nvim-treesitter').install(parsers)
end

M.config = function()
  M.install_parsers()

  vim.keymap.set('n', '<C-Space>', function()
    require('nvim.treesitter.selection').start()
  end, { desc = 'Start selection' })

  vim.keymap.set('x', '<C-Space>', function()
    require('nvim.treesitter.selection').increment()
  end, { desc = 'Increment selection' })

  vim.keymap.set('x', '<BS>', function()
    require('nvim.treesitter.selection').decrement()
  end, { desc = 'Decrement selection' })
end

--- Check if the current node is a comment node
---@return boolean
M.in_comment_node = function()
  local success, node = pcall(vim.treesitter.get_node)
  if success and node then
    return vim.tbl_contains({
      'comment',
      'line_comment',
      'block_comment',
      'comment_content',
    }, node:type())
  end
  return false
end

return M
