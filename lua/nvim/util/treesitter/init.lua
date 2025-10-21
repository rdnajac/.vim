local M = {}

M.query_langs = function(buf)
  local highlighter = require('vim.treesitter.highlighter')
  buf = buf or vim.api.nvim_get_current_buf()
  local hl = highlighter.active[buf]
  if hl then
    return vim.tbl_keys(hl._queries)
  end
end

M.query_icons = function(buf)
  return vim.tbl_map(function(lang)
    return nv.icons.filetype[lang]
  end, M.query_langs(buf))
end

-- TODO:  report language
M.status = function()
  local highlighter = require('vim.treesitter.highlighter')
  local buf = vim.api.nvim_get_current_buf()
  if highlighter.active[buf] then
    return table.concat(M.query_icons(buf), ' ')
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
  -- TODO:  call mason install utility
end

return setmetatable(M, {
  __index = function(t, k)
    t[k] = require('nvim.util.treesitter.' .. k)
    return t[k]
  end,
})
