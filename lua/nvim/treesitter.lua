local M = { 'nvim-treesitter/nvim-treesitter' }

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
  autostart({ 'markdown', 'python' })
  autostart({ 'sh', 'zsh' }, 'bash')
end

-- M.keys = function()
--   return {}
-- end

  -- stylua: ignore
M.after = function()
  vim.keymap.set('n', '<C-Space>', function() require('nvim.treesitter.selection').start() end, { desc = 'Start selection' })
  vim.keymap.set('x', '<C-Space>', function() require('nvim.treesitter.selection').increment() end, { desc = 'Increment selection' })
  vim.keymap.set('x', '<BS>', function() require('nvim.treesitter.selection').decrement() end, { desc = 'Decrement selection' })
end

--- Check if the current node is a comment node
--- @param pos? integer[] position {line, col} 0-indexed
--- @return boolean
M.in_comment_node = function(pos)
  local ok, node = pcall(vim.treesitter.get_node, {
    bufnr = 0,
    pos = pos,
  })
  if not ok or not node then
    return false
  end
  return vim.tbl_contains(
    { 'comment', 'line_comment', 'block_comment', 'comment_content' },
    node:type()
  )
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

M._installed = nil ---@type table<string,string>?

---@param update boolean?
function M.get_installed(update)
  if update then
    M._installed = {}
    for _, lang in ipairs(require('nvim-treesitter').get_installed('parsers')) do
      M._installed[lang] = lang
    end
  end
  return M._installed or {}
end

M.install_cli = function()
  if vim.fn.executable('tree-sitter') == 1 then
    return
  end

  --- @module 'mason'
  local reg = nv.mason.reg()
  reg.refresh(function()
    local p = reg.get_package('tree-sitter-cli')
    if not p:is_installed() then
      nv.mason.install(p)
    end
  end)
end

return M
