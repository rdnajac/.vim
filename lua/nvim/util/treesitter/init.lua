local M = {}

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
  -- TODO:  call mason isntall utility
end

return setmetatable(M, {
  __index = function(t, k)
    t[k] = require('nvim.util.treesitter.' .. k)
    return t[k]
  end,
})
