local M = {}

M.copilot_icon = function()
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.name == 'GitHub Copilot' then
      return ' '
    end
  end
  return ''
end

M.filetype_icon = function()
  local ok, devicons = pcall(require, 'nvim-web-devicons')
  if not ok then
    return ''
  end
  return devicons.get_icon(vim.fn.expand('%:t'), nil, { default = true })
    or devicons.get_icon_by_filetype(vim.bo.filetype, { default = true })
    or ''
end

M.lsp_icon = function()
  for _, client in pairs(vim.lsp.get_clients()) do
    if client.name ~= 'GitHub Copilot' then
      return ' '
    end
  end
  return ''
end

M.treesitter_icon = function()
  local highlighter = require('vim.treesitter.highlighter')
  local buf = vim.api.nvim_get_current_buf()
  if highlighter.active[buf] then
    return ' '
  end
  return ''
end

function M.docsymbols()
  return require('vimline.docsymbols').get_location()
end

function M.docsymbols_hl()
  return require('vimline.docsymbols').get_location({ apply_hl = true })
end

function M.mode()
  return require('nvim.util.mode').get()
end

function M.blink()
  return require('vimline.blink').source_status()
end

function M.lspprogress()
  return require('vimline.lspprogress').status()
end

-- TODO: terminal information
-- local chan = vim.b.terminal_job_id or '?'
-- local term_title = vim.b.term_title or ''

return M
