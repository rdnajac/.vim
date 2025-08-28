local icons = nvim.icons
-- Escape `%` in str so it doesn't get picked as stl item.
local vimlineescape = function(str)
  return type(str) == 'string' and str:gsub('%%', '%%%%') or str
end

local M = setmetatable({}, {
  __index = function(_, key)
    return require('vimline.' .. key)
  end,
})

M.file_format = require('vimline.file').format
M.file_size = require('vimline.file').size
M.hostname = function()
  vimlineescape(vim.loop.os_gethostname())
end

M.docsymbols = function()
  return require('nvim.lsp.docsymbols').get()
end

-- TODO: use mini.icons directly
--- Get devicon for a buffer by buffer number.
--- @param bufnr number|nil Buffer number (defaults to current buffer)
--- @return string icon
M.ft_icon = function(bufnr)
  local ok, devicons = pcall(require, 'nvim-web-devicons')
  if not ok then
    return ''
  end

  bufnr = bufnr or vim.api.nvim_get_current_buf()

  -- intercept special types
  local ft = vim.bo[bufnr] and vim.bo[bufnr].filetype or ''
  if ft == 'help' then
    return '󰋖 '
  elseif ft == 'oil' then
    return ' '
  end

  local fname = vim.api.nvim_buf_get_name(bufnr)
  local shortname = vim.fn.fnamemodify(fname, ':t')
  local ext = vim.fn.fnamemodify(fname, ':e')

  local icon = devicons.get_icon(shortname, ext, { default = true })
    or devicons.get_icon_by_filetype(ft, { default = true })
    or ''

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
  return string.format('%s%s%s', M.lsp_icon(),  M.copilot_icon(), M.treesitter_icon())
end

return M
