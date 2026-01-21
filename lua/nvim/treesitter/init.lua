local M = {}

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

--- Check if the current node is a comment node
---@param ... any no args: use cursor
---@return boolean
M.is_comment = function(...)
  local pos = require('nvim.util.pos')(...)
  -- HACK: subtract 1 from col to avoid edge cases
  -- pos = vim.pos(pos.row, math.max(0, pos.col - 1))
  local ok, node = pcall(vim.treesitter.get_node, { bufnr = 0, pos = pos:to_extmark() })
  return ok
      and node
      and vim.tbl_contains({
        'comment',
        'line_comment',
        'block_comment',
        'comment_content',
      }, node:type())
    or false
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

return setmetatable(M, {
  __index = function(t, k)
    t[k] = require('nvim.treesitter.' .. k)
    return t[k]
  end,
})
