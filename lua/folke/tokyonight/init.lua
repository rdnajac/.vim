local mycolors = {
  -- tokyonight = '#24283b',
  black = '#000000',
  eigengrau = '#16161d',
  blue = '#14afff',
  green = '#39ff14', -- orig: #9ece6a
  lualine = '#3b4261',
}

--- for the palette, go to:
--- `~/.local/share/nvim/site/pack/core/opt/tokyonight.nvim/lua/tokyonight/colors/storm.lua`
---@param c ColorScheme
---@return tokyonight.Highlights
local myhighlights = function(c)
  return {
    -- Normal = vim.g.transparent ~= true and { bg = c.black } or nil,
    Normal = { bg = c.black },
    -- Function = { fg = c.blue },
    Number = { fg = c.blue },
    Special = { fg = c.red, bold = true },
    SpellBad = { bg = c.red },
    -- Statement = { fg = c.red },
    StatusLine = { bg = 'NONE' },
    -- lsp
    -- ['@property'] = { fg = c.yellow },
    -- ['@keyword.function'] = { fg = c.red },
    -- ['@variable.parameter'] = { fg = c.magenta },
    -- ['@variable.member'] = { fg = c.blue },
  }
end

local M = {}

-- ~/.local/share/nvim/site/pack/core/opt/tokyonight.nvim/lua/tokyonight/groups/
M.plugins = function()
  local plugins = { all = false }
  local groups = require('tokyonight.groups')

  for plugin, group in pairs(groups.plugins) do
    if vim.fn.isdirectory(vim.g.plug_home .. '/' .. plugin) ~= 0 then
      plugins[group] = true
    end
  end

  -- `mini.nvim`
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
    -- 'operators'
    -- 'pick',
    -- 'starter',
    -- 'statusline',
    'surround',
    -- 'tabline',
    -- 'test',
    -- 'trailspace',
  }) do
    plugins['mini_' .. mod] = true
  end
  return plugins
end

M.get_plugins = function()
  local ok, plugins = pcall(require, 'folke.tokyonight.gen.plugins')
  if not ok then
    M.generate_plugins()
    return M.plugins()
  end
  return plugins
end

vim.g.transparent = true

---@type tokyonight.Config
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
    for k, v in pairs(mycolors) do
      colors[k] = v
    end
  end,
  on_highlights = function(hl, colors)
    for k, v in pairs(myhighlights(colors)) do
      hl[k] = v
    end
  end,
  -- plugins = { all = false },
  plugins = M.get_plugins(),
}

M.config = function()
  require('tokyonight').setup(opts)
end

M.setup = function()
  return require('tokyonight.theme').setup(opts)
end

M.colorscheme = function()
  ---@type ColorScheme, tokyonight.Highlights, tokyonight.Config
  M.colors, M.groups, M.opts = M.setup()
  -- `load()` won't trigger ColorScheme autocommand, so do it here
  vim.cmd.doautocmd({ '<nomodeline>', 'ColorScheme' })
end

--- Write content to a file in the colors directory
---@param filename string The name of the file (can include subdirectory path)
---@param content string|string[] Content to write (string or array of lines)
M.write = function(filename, content)
  local f = require('nvim.util.file')
  local filepath = filename
  if type(content) == 'table' then
    f.write_lines(filepath, content)
  else
    f.write(filepath, content)
  end
end

M.write_groups = function()
  local groups = M.groups
  local content = 'return ' .. vim.inspect(groups)
  M.write('gen/groups.lua', content)
end

--- Generate the plugins.lua file with current plugin configuration
M.generate_plugins = function()
  local plugins = M.plugins()
  local content = 'return ' .. vim.inspect(plugins)
  M.write('gen/plugins.lua', content)
end

M.setup()

return M
