local M = {}

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
  -- TODO:  call mason install utility
end

return setmetatable(M, {
  __index = function(t, k)
    t[k] = require('nvim.util.treesitter.' .. k)
    return t[k]
  end,
})
