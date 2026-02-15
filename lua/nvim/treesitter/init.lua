local nv = _G.nv or require('nvim.util')
local M = {}
M.parsers = require('nvim.treesitter.parsers')
M.selection = require('nvim.treesitter.selection')
M.specs = {
  {
    'nvim-treesitter/nvim-treesitter',
    build = function() vim.cmd('TSUpdate | TSInstall! ' .. table.concat(M.parsers.to_install, ' ')) end,
    keys = {
      { 'n', '<C-Space>', M.selection.start, { desc = 'Start ts selection' } },
      { 'x', '<C-Space>', M.selection.increment, { desc = 'Increment ts selection' } },
      { 'x', '<BS>', M.selection.decrement, { desc = 'Decrement ts selection' } },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    toggles = {
      ['<leader>ux'] = {
        name = 'Treesitter Context',
        get = function() return require('treesitter-context').enabled() end,
        set = function() require('treesitter-context').toggle() end,
      },
    },
  },
  -- require('nvim.treesitter.textobjects'),
}

---@type table<string,string>?
M._installed = nil

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

M.status = {
  function()
    local ret = {}
    local highlighter = require('vim.treesitter.highlighter')
    local hl = highlighter.active[vim.api.nvim_get_current_buf()]
    ---@diagnostic disable-next-line: invisible
    local queries = hl and hl._queries
    if type(queries) == 'table' then
      ret = vim.tbl_map(function(query)
        if query == vim.bo.filetype then
          return ' '
        end
        return nv.icons.filetype[query]
      end, vim.tbl_keys(queries))
    end
    return table.concat(ret, ' ')
  end,
}

M.install_cli = function()
  if vim.fn.executable('tree-sitter') == 1 then
    return
  end
  -- TODO: use mason install utility
end

local _is_comment = {
  comment = true,
  line_comment = true,
  block_comment = true,
  comment_content = true,
}

M.node_is_comment = function(node) return _is_comment[node:type()] == true end

return M
