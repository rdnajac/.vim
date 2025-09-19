-- TODO: configure debuging with
-- nvim_eval_statusline()
local icons = nv.icons
-- Escape `%` in str so it doesn't get picked as stl item.
local vimlineescape = function(str)
  return type(str) == 'string' and str:gsub('%%', '%%%%') or str
end

local M = setmetatable({}, {
  __index = function(_, key)
    return require('vimline.' .. key)
  end,
})

M.diagnostics = function()
  local counts = vim.diagnostic.count(0)
  local signs = vim.diagnostic.config().signs

  if not signs or vim.tbl_isempty(counts) then
    return ''
  end

  return vim
    .iter(pairs(counts))
    :map(function(severity, count)
      local icon = signs.text[severity]
      local hl_group = signs.numhl[severity]
      return string.format('%%#%s#%s:%d', hl_group, icon, count)
    end)
    :join('')
end

M.file_format = require('vimline.file').format
M.file_size = require('vimline.file').size
M.hostname = function()
  vimlineescape(vim.loop.os_gethostname())
end

M.docsymbols = function()
  return require('nvim.lsp.docsymbols').get()
end

--- Get icon for a buffer by buffer number or filetype
---@param bufnr_or_ft number|string|nil
---@return string icon
M.ft_icon = function(bufnr_or_ft)
  local ft

  if type(bufnr_or_ft) == 'string' then
    ft = bufnr_or_ft
  else
    local bufnr = bufnr_or_ft or vim.api.nvim_get_current_buf()
    ft = vim.bo[bufnr].filetype
  end

  local icon = ft and MiniIcons.get('filetype', ft) or nv.icons.files.file
  return icon .. ' '
end

M.copilot_icon = function()
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.name == 'copilot' then
      return icons.src.copilot
    end
  end
  return ''
end

M.lsp_icon = function()
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.name ~= 'copilot' then
      return icons.lsp.attached
    end
  end
  return icons.lsp.unavailable .. ' '
end

M.treesitter_icon = function()
  local highlighter = require('vim.treesitter.highlighter')
  local buf = vim.api.nvim_get_current_buf()
  if highlighter.active[buf] then
    return ' '
  end
  return ''
end

local sep = ''

M.lua_icons = function()
  return string.format('%s%s%s%s%s', M.lsp_icon(), sep, M.copilot_icon(), sep, M.treesitter_icon())
end

M.winbar_icons = function()
  return string.format('%s%s%s', M.lsp_icon(), M.copilot_icon(), M.treesitter_icon())
end

return M
