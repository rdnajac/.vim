vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath('state') .. '/backup//'
vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'
vim.opt.cmdheight = 0
-- vim.opt.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
vim.opt.mousescroll = 'hor:0'
vim.opt.pumblend = 0
vim.opt.signcolumn = 'yes'
vim.opt.smoothscroll = true
vim.opt.winborder = 'rounded'
vim.opt.jumpoptions = 'view,stack'

-- HACK: don't show lualine on dashboard
if vim.fn.argc(-1) == 0 and vim.bo.filetype == 'snacks_dashboard' then
  vim.opt.laststatus = 0
end

-- TODO: use snacks highlight
local base_statusline_highlights =
  { 'StatusLine', 'StatusLineNC', 'Tabline', 'TabLineFill', 'TabLineSel', 'Winbar', 'WinbarNC' }

for _, hl_group in pairs(base_statusline_highlights) do
  vim.api.nvim_set_hl(0, hl_group, { bg = 'NONE' })
end

require('nvim.options.diagnostic')
require('nvim.options.folding')
require('nvim.options.lsp')
require('nvim.options.x')
