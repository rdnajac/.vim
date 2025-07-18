local M = {}

M.copilot_icon = function()
  for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
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

M.treesitter_icon = function()
  local highlighter = require('vim.treesitter.highlighter')
  local buf = vim.api.nvim_get_current_buf()
  if highlighter.active[buf] then
    return ' '
  end
  return ''
end

function M.docsymbols()
  return require('util.lualine.docsymbols').get_location()
end

function M.mode()
  return require('util.mode').get()
end

return M

-- local unused = {
--   { 'mode', separator = { right = '' } },
--   {
--     '%S',
--     cond = function()
--       local ok, res = pcall(vim.api.nvim_eval_statusline, '%S', {})
--       return ok and res and res.str ~= ''
--     end,
--   },
--   Snacks.profiler.status(),
--   { require('spec.lualine.components.lsp_status') },
--   {
--     'diagnostics',
--     symbols = require('nvim.ui.icons').diagnostics,
--     always_visible = true,
--     color = { bg = '#3b4261' },
--   },
--   require('spec.lualine.components.navic'),
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
