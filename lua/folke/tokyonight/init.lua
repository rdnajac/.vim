-- write cache
local mycolors = {
  -- tokyonight = '#24283b',
  black = '#000000',
  eigengrau = '#16161d',
  blue = '#14afff',
  green = '#39ff14', -- orig: #9ece6a
  lualine = '#3b4261',
}

--- for the original palette, see: `tokyonight.colors.storm`
---@param c ColorScheme
---@return tokyonight.Highlights
local myhighlights = function(c)
  return {
    -- Normal = vim.g.transparent ~= true and { bg = c.black } or nil,
    -- Normal = { bg = c.black },
    -- Number = { fg = c.blue },
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

local myplugins = function()
  local plugins = { all = false }
  vim
    .iter(require('tokyonight.groups').plugins)
    :filter(function(plugin) return vim.uv.fs_stat(vim.g.plug_home .. '/' .. plugin) end)
    :each(function(plugin, group) plugins[group] = true end)

  -- `mini.nvim`
  for _, mod in ipairs({
    -- 'animate', 'clue', 'completion', 'cursorword', 'deps',
    'diff',
    'files',
    'hipatterns',
    'icons',
    -- 'indentscope', 'jump', 'map', 'notify', 'operators' 'pick', 'starter',
    'surround',
    -- 'statusline', 'tabline', 'test', 'trailspace',
  }) do
    plugins['mini_' .. mod] = true
  end
  return plugins
end

vim.g.transparent = true

---@return tokyonight.Config
local _opts = function()
  return {
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
    plugins = M.cache('plugins', myplugins),
  }
end

--- Calls `require('tokyonight').setup` with local opts which
--- are then merged with the default opts and stored on
--- `require('tokyonight.config').options` This is referred to
--- as config since it fits the common pattern `plugin.setup(opts)`.
M.config = function() require('tokyonight').setup(_opts()) end

--- require('tokyonight').setup actually points to this function (unused here)
M._setup = function() require('tokyonight.config').setup() end

---@alias retvals {ColorScheme, tokyonight.Highlights, tokyonight.Config}

--- The actual setup function (usually called from `require.('tokyonight').load`).
--- Here, opts are still merged with the default opts, but not stored.
---@return ColorScheme, tokyonight.Highlights, tokyonight.Config
M.setup = function() return require('tokyonight.theme').setup(_opts()) end

--- get low
---@return ColorScheme, tokyonight.Highlights, tokyonight.Config
local _load = function()
  local opts = require('tokyonight.config').extend(_opts())
  local colors = require('tokyonight.colors').setup(opts)
  local groups = require('tokyonight.groups').setup(colors, opts)
  return opts, colors, groups
end

  local opts = require('tokyonight.config').extend(_opts())
print(opts)

--- Call setup and store results on this module
M._colorscheme = function()
  M.colors, M.groups, M.opts = M.setup()
end

--- Setup highlights and trigger `ColorScheme` autocmd since `setup` does not
M.colorscheme = function()
  M._colorscheme()
  vim.cmd.doautocmd({ '<nomodeline>', 'ColorScheme' })
end

--- Write content to a file
---@param path string Absolute path to the file
---@param content any Content to write (string, list, or table)
local write = function(path, content)
  local f = require('nvim.util.file')
  local output
  if type(content) == 'string' then
    output = content
  elseif vim.islist(content) and type(content[1]) == 'string' then
    output = table.concat(content, '\n')
  else
    output = vim.inspect(content)
  end
  f.write(path, output)
end

--- Load table from cache or generate and cache it
---@param name string The name suffix for tokyonight_<name>.lua
---@param generator function Function to generate data if cache miss
M.cache = function(name, generator)
  -- `~/.cache/nvim/colors/`
  local path = vim.fs.joinpath(vim.fn.stdpath('cache'), 'colors', 'tokyonight_' .. name .. '.lua')
  if vim.uv.fs_stat(path) then
    local ok, data = pcall(dofile, path)
    if ok and data then
      return data
    end
  end
  local data = generator()
  write(path, data)
  return data
end

function M.gen(user_opts)
  local lines = {}
  for group, hl in pairs(groups) do
    hl = type(hl) == 'string' and { link = hl } or hl
    table.insert(
      lines,
      string.format(
        'vim.api.nvim_set_hl(0, %q, %s)',
        group,
        vim.inspect(hl, { newline = '', indent = '' })
      )
    )
  end

  local path = vim.fs.joinpath(vim.env.HOME, '.vim', 'colors', 'tokyonight_generated.lua')
  write(path, lines)
  return path
end

---@param user_opts? tokyonight.Config
---@param force? boolean Force regeneration of cache
function M.__setup(user_opts, force)
  local groups = force and nil
    or M.cache('groups', function()
      local opts = require('tokyonight.config').extend(user_opts)
      local colors = require('tokyonight.colors').setup(opts)
      return require('tokyonight.groups').setup(colors, opts)
    end)

  if not groups or force then
    local opts = require('tokyonight.config').extend(user_opts)
    local colors = require('tokyonight.colors').setup(opts)
    groups = require('tokyonight.groups').setup(colors, opts)
    local cache_path = vim.fs.joinpath(vim.fn.stdpath('cache'), 'colors', 'tokyonight_groups.lua')
    write(cache_path, groups)
  end

  local opts = require('tokyonight.config').extend(user_opts)
  local colors = require('tokyonight.colors').setup(opts)

  for group, hl in pairs(groups) do
    hl = type(hl) == 'string' and { link = hl } or hl
    vim.api.nvim_set_hl(0, group, hl)
  end
  M.terminal(colors)
  return colors, groups, opts
end

---@param colors ColorScheme
function M.terminal(colors)
    -- stylua: ignore
  for idx, name in ipairs({
    'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white',
  }) do
    vim.g['terminal_color_' .. (idx - 1)] = colors.terminal[name]
    vim.g['terminal_color_' .. (idx + 7)] = colors.terminal[name .. '_bright']
  end
end

M.gen(opts())

return M
