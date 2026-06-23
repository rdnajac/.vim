local colors = require('nvim.tokyonight.colors')
local c = colors.colors
local ret = vim
  .iter(require('nvim.tokyonight.groups'))
  :fold({}, function(acc, _, v) return vim.tbl_extend('force', acc, v) end)

local cache = require('nvim.tokyonight').cache
cache.write({ colors = c, ret = ret })

-- m.colorscheme(groups)
vim.iter(ret):each(function(name, hl)
  hl = type(hl) == 'string' and { link = hl } or hl
  vim.api.nvim_set_hl(0, name, hl)
end)

-- m.terminal(colors)
for i, color in ipairs({ 'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white' }) do
  vim.g['terminal_color_' .. (i - 1)] = c.terminal[color]
  vim.g['terminal_color_' .. (i + 7)] = c.terminal[color .. '_bright']
end

Snacks.util.set_hl({
  Azure = { fg = c.blue2 },
  Blue = { fg = c.blue },
  Cyan = { fg = c.teal },
  Green = { fg = c.green },
  Grey = { fg = c.fg },
  Orange = { fg = c.orange },
  Purple = { fg = c.purple },
  Red = { fg = c.red },
  Yellow = { fg = c.yellow },
}, { 'MiniIcons' })

-- vim: fdl=2
