local M = {}

-- M.indicator = function()

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

print(M.docsymbols())

function M.docsymbols_hl()
  return require('vimline.docsymbols').get_location({ apply_hl = true })
end

print(M.docsymbols_hl())

function M.mode()
  return require('util.mode').get()
end

function M.blink()
  return require('vimline.blink').source_status()
end

return M
--   { require('spec.lualine.components.lsp_status') },
--   { 'diagnostics', symbols = require('nvim.ui.icons').diagnostics, },
--
--   -- extensions
--   Man = {
--     winbar = {
--       lualine_a = {
--         function()
--           return 'MAN'
--         end,
--       },
--       lualine_b = { { 'filename', file_status = false } },
--       lualine_y = { 'progress' },
--       lualine_z = { 'location' },
--     },
--     filetypes = { 'man' },
--   },
--
--   snacks_terminal = {
--     sections = {
--       lualine_a = {
--         { 'mode', separator = { right = '' } },
--       },
--       lualine_b = {
--         {
--           function()
--             local chan = vim.b.terminal_job_id or '?'
--             return 'channel: ' .. tostring(chan)
--           end,
--           separator = { right = '' },
--         },
--       },
--       lualine_c = {
--         function()
--           return vim.b.term_title or ''
--         end,
--       },
--     },
--     filetypes = { 'snacks_terminal' },
--   },
-- }
