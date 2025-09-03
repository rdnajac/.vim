local M = { 'folke/tokyonight.nvim' }

local bg = {
  black = '#000000',
  eigengrau = '#16161d',
  darkgrey = '#1f2335',
  tokyonight = '#24283b',
  lualine = '#3b4261',
}

---@type tokyonight.Config
M.opts = {
  style = 'night',
  transparent = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = false, bold = true },
    -- variables = { italic = true },
    sidebars = 'transparent',
    floats = 'transparent',
  },
  dim_inactive = true,
  on_colors = function(colors)
    colors.blue = '#14afff'
    colors.green = '#39ff14'
  end,
  on_highlights = function(hl, colors)
    hl['Cmdline'] = { bg = bg.black }
    hl['Statement'] = { fg = colors.red }
    hl['Special'] = { fg = colors.red, bold = true }
    hl['SpellBad'] = { bg = colors.red }
    hl['WinBar'] = { bg = bg.lualine }
    hl['WinBorder'] = { bg = bg.lualine }
    hl['SpecialWindow'] = { bg = bg.eigengrau }
    hl['Green'] = { fg = colors.green }
  end,
  plugins = {
    all = false,
    mini = true,
    snacks = true,
    ['render-markdown.nvim'] = true,
    -- copilot = vim.g.loaded_copilot == 1,
  },
}

---@param file string
---@param contents string
local function _write(file, contents)
  vim.fn.mkdir(vim.fn.fnamemodify(file, ':h'), 'p')
  local fd = assert(io.open(file, 'w+'))
  fd:write(contents)
  fd:close()
end

local want = {
  ghostty = '',
  lazygit = '',
  slack = '',
  spotify_player = '~/.config/spotify-player/theme.toml',
  lua = '',
  vim = '~/.vim/colors/tokyomidnight.vim',
}

M.build = function()
  -- TODO: make sure config is loaded
  local extras = require('tokyonight.extra').extras
  local style = 'midnight'
  local style_name = ''
  local colors = M.colors

  for name, location in pairs(want) do
    local info = extras[name]
    if not info then
      Snacks.notify.warn('tokyonight.extra: unknown extra "' .. name .. '"')
    else
      local plugin = require('tokyonight.extra.' .. name)
      local fname
      if location and location ~= '' then
        fname = vim.fn.fnamemodify(location, ':p')
      else
        fname = name
          .. (info.subdir and '/' .. info.subdir .. '/' or '')
          .. '/tokyonight'
          .. (info.sep or '_')
          .. style
          .. '.'
          .. info.ext
        fname = string.gsub(fname, '%.$', '') -- remove trailing dot
        fname = vim.fn.fnamemodify('~/tokyonight/' .. fname, ':p')
      end

      colors['_style_name'] = 'Tokyo Night' .. style_name
      colors['_name'] = 'tokyonight_' .. style
      colors['_style'] = style
      print('Writing ' .. fname)
      _write(fname, plugin.generate(colors, M.groups, M.opts))
    end
  end
end

return M
