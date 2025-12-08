local M = { 'folke/tokyonight.nvim' }

local mycolors = {
  -- tokyonight = '#24283b',
  black = '#000000',
  eigengrau = '#16161d',
  blue = '#14afff',
  -- green = '#39ff14',
  lualine = '#3b4261',
}

vim.g.transparent = true

---@param colors ColorScheme
---@return tokyonight.Highlights
local myhighlights = function(colors)
  return {
    Normal = vim.g.transparent ~= true and { bg = colors.black } or nil,
    -- ['@keyword'] = { fg = colors.red },
    Special = { fg = colors.red, bold = true },
    Number = { fg = colors.blue },
    SpellBad = { bg = colors.red },
  }
end

---@return tokyonight.Config
local opts = function()
  local ret = {
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
      for k, v in pairs(mycolors) do
        colors[k] = v
      end
    end,
    on_highlights = function(hl, colors)
      for k, v in pairs(myhighlights(colors)) do
        hl[k] = v
      end
    end,
    plugins = {
      all = false,
      mini = true,
    },
  }

  -- ~/.local/share/nvim/site/pack/core/opt/tokyonight.nvim/lua/tokyonight/groups/
  for plugin, group in pairs(require('tokyonight.groups').plugins) do
    if vim.fn.isdirectory(vim.g.plug_home .. '/' .. plugin) ~= 0 then
      ret.plugins[group] = true
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
    ret.plugins['mini_' .. mod] = true
  end

  return ret
end

M.config = function()
  local opts = opts()
  require('tokyonight').setup(opts)
  -- ---
  -- --- @type ColorScheme, tokyonight.Highlights, tokyonight.Config
  M.colors, M.groups, M.opts = require('tokyonight').load(opts)
  --
  -- -- `load()` won't trigger ColorScheme autocommand, so do it here
  vim.cmd.doautocmd({ '<nomodeline>', 'ColorScheme' })
end

-- write colors opts and grouos to a file: ~/.vim/tokyonight/debug/{colors,opts,groups}.lua
-- use nv.file.write
M.debug = function()
  local debug_dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'gen', 'tokyonight', 'debug')
  for _, fname in ipairs({ 'colors', 'groups', 'opts' }) do
    nv.file.write(vim.fs.joinpath(debug_dir, fname .. '.lua'), 'return ' .. vim.inspect(M[fname]))
  end
end

return M
