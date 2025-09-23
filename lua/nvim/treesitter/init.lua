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

M.config = function()
  autostart({ 'sh', 'markdown', 'r', 'python', 'vim' })
  autostart({ 'zsh' }, 'bash')
end

-- M.keys = {
--
-- }

M.after = function()
  require('nvim.treesitter.mycommentparser')
  -- stylua: ignore start
  vim.keymap.set('n', '<C-Space>', function() require('nvim.treesitter.selection').start() end, { desc = 'Start selection' })
  vim.keymap.set('x', '<C-Space>', function() require('nvim.treesitter.selection').increment() end, { desc = 'Increment selection' })
  vim.keymap.set('x', '<BS>', function() require('nvim.treesitter.selection').decrement() end, { desc = 'Decrement selection' })
  vim.keymap.set('n', '<leader>uI', function() vim.treesitter.inspect_tree(); vim.api.nvim_input('I') end, { desc = 'Inspect Tree' })
  -- stylua: ignore end
  Snacks.toggle.treesitter():map('<leader>ut')
end

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

-- TODO:  report language
M.status = function()
  local highlighter = require('vim.treesitter.highlighter')
  local buf = vim.api.nvim_get_current_buf()
  if highlighter.active[buf] then
    return ' '
  end
  return ''
end



return M
