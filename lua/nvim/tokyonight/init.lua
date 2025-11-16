vim.g.transparent = true

local mycolors = {
  -- tokyonight = '#24283b',
  black = '#000000',
  eigengrau = '#16161d',
  blue = '#14afff',
  green = '#39ff14',
  lualine = '#3b4261',
}

---@param colors ColorScheme
---@return tokyonight.Highlights
local myhighlights = function(colors)
  -- stylua: ignore
  return {
    Normal        = vim.g.transparent and { bg = colors.black } or nil,
    Cmdline       = { bg = colors.black },
    Statement     = { fg = colors.red },
    Special       = { fg = colors.red, bold = true },
    SpellBad      = { bg = colors.red },
    WinBar        = { bg = mycolors.lualine },
    WinBorder     = { bg = mycolors.lualine },
    SpecialWindow = { bg = mycolors.eigengrau },
  }
end

local M = {}

--- @type tokyonight.Config
local opts = {
  style = 'night',
  transparent = vim.g.transparent == true,
  styles = {
    comments = { italic = true },
    keywords = { italic = false, bold = true },
    variables = { italic = false },
    floats = vim.g.transparent == true and 'transparent' or nil,
    sidebars = vim.g.transparent == true and 'transparent' or nil,
  },
  dim_inactive = true,
  on_colors = function(colors)
    vim.tbl_extend('force', colors, mycolors)
  end,
  on_highlights = function(hl, colors)
    vim.tbl_extend('force', hl, myhighlights(colors))
  end,
  plugins = {
    all = false,
    mini = true,
  },
}

-- ~/.local/share/nvim/site/pack/core/opt/tokyonight.nvim/lua/tokyonight/groups/
for plugin, group in pairs(require('tokyonight.groups').plugins) do
  if vim.fn.isdirectory(vim.g.plug_home .. '/' .. plugin) ~= 0 then
    opts.plugins[group] = true
  end
end

for _, mod in ipairs({
  -- 'animate',
  -- 'clue',
  -- 'completion',
  -- 'cursorword',
  -- 'deps',
  'diff',
  'files',
  'hipatterns',
  'icons',
  -- 'indentscope',
  -- 'jump',
  -- 'map',
  -- 'notify',
  -- 'operators',
  -- 'pick',
  -- 'starter',
  -- 'statusline',
  'surround',
  -- 'tabline',
  -- 'test',
  -- 'trailspace',
}) do
  opts.plugins['mini_' .. mod] = true
end

require('tokyonight').setup(opts)
---
--- @type ColorScheme, tokyonight.Highlights, tokyonight.Config
M.colors, M.groups, M.opts = require('tokyonight').load()

-- `load()` won't trigger ColorScheme autocommand, so do it here
vim.cmd.doautocmd({ '<nomodeline>', 'ColorScheme' })

-- write colors opts and grouos to a file: ~/.vim/tokyonight/debug/{colors,opts,groups}.lua
-- use nv.file.write
M.debug = function()
  local debug_dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'gen', 'tokyonight', 'debug')
  for _, fname in ipairs({ 'colors', 'groups', 'opts' }) do
    nv.file.write(vim.fs.joinpath(debug_dir, fname .. '.lua'), 'return ' .. vim.inspect(M[fname]))
  end
end

return M
