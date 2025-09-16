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
  pattern = 'lua',
  group = aug,
  command = 'syntax on',
  -- callback = function(args)
  --   vim.bo[args.buf].syntax = 'ON'
  -- end,
  desc = 'Keep using legacy syntax (for `vim-endwise`)',
})

--- Autostart treesitter for certain filetypes
--- @param ft string|string[] filetype or list of filetypes
--- @param force string|nil optional override for the parser to use
local autostart = function(ft, override)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = ft,
    group = aug,
    callback = function(args)
      -- vim.treesitter.start()
      vim.treesitter.start(args.buf, override)
    end,
    desc = 'Start Tree-sitter for certain filetypes',
  })
end

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

M.config = function()
  autostart({ 'sh', 'markdown', 'r', 'python', 'kitty' })
  autostart({ 'kitty', 'ghostty', 'zsh' }, 'bash')
end

M.after = function()
  -- stylua: ignore start
  vim.keymap.set('n', '<C-Space>', function() require('nvim.treesitter.selection').start() end, { desc = 'Start selection' })
  vim.keymap.set('x', '<C-Space>', function() require('nvim.treesitter.selection').increment() end, { desc = 'Increment selection' })
  vim.keymap.set('x', '<BS>', function() require('nvim.treesitter.selection').decrement() end, { desc = 'Decrement selection' })
  vim.keymap.set('n', '<leader>uI', function() vim.treesitter.inspect_tree(); vim.api.nvim_input('I') end, { desc = 'Inspect Tree' })
  -- stylua: ignore end

  Snacks.toggle.treesitter():map('<leader>ut')

  require('nvim.treesitter.mycommentparser')
end
-- TODO: add vimline component
-- report treesiter language

return M
