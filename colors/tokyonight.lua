package.preload['tokyonight.colors'] = function() return require('nvim.tokyonight.colors') end
package.preload['tokyonight.groups'] = function() return require('nvim.tokyonight.groups') end

local m = require('nvim.tokyonight')
local opts = m.opts
local colors = require('tokyonight.colors').setup(opts)
local groups = require('tokyonight.groups').setup(colors, opts)

-- m.colorscheme(groups)
vim.iter(groups):each(function(name, hl)
  hl = type(hl) == 'string' and { link = hl } or hl
  vim.api.nvim_set_hl(0, name, hl)
end)

-- m.terminal(colors)
for i, color in ipairs({ 'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white' }) do
  vim.g['terminal_color_' .. (i - 1)] = colors.terminal[color]
  vim.g['terminal_color_' .. (i + 7)] = colors.terminal[color .. '_bright']
end
