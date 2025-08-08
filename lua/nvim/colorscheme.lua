local M = {}

M.specs = {
  -- 'catppuccin/nvim',
  'projekt0n/github-nvim-theme',
  'folke/tokyonight.nvim',
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
    -- colors.red = '#f7768e'
  end,
  on_highlights = function(hl, colors)
    hl['Statement'] = { fg = colors.red }
    hl['Special'] = { fg = colors.red, bold = true }
    hl['SpellBad'] = { bg = colors.red }
    hl['SpecialWindow'] = { bg = '#1f2335' }
    -- TODO: move to vimline?
    -- hl['StatusLineNC'] = { bg = 'NONE' }
    -- hl['TabLineFill'] = { bg = 'NONE' }
    -- hl['Winbar'] = { bg = 'NONE' }
    hl['Cmdline'] = { bg = '#000000' }
  end,
  plugins = {
    all = false,
    ale = vim.g.loaded_ale == 1,
    -- copilot = true,
    -- fzf = true,
    -- mini = true,
    -- ['render-markdown.nvim'] = true,
    -- snacks = true,
    -- treesitter = false,
    -- semantic_tokens = false,
    -- kinds = false,
  },
}

M.config = function()
  vim.pack.add(vim.tbl_map(function(s)
    return 'https://github.com/' .. s
  end, M.specs))
  return require('tokyonight').load(M.opts)
end

---@param file string
---@param contents string
local function _write(file, contents)
  vim.fn.mkdir(vim.fn.fnamemodify(file, ':h'), 'p')
  local fd = assert(io.open(file, 'w+'))
  fd:write(contents)
  fd:close()
end

local want = {
  ghostty = {},
  lazygit = {},
  slack = {},
  spotify_player = { location = '~/.config/spotify-player/theme.toml' },
  lua = {},
  vim = {},
}

M.build = function()
  local extras = require('tokyonight.extra').extras
  local colors, groups, opts = require('tokyonight').load(M.opts)
  local style = 'midnight'
  local style_name = ''

  for name, user_opts in pairs(want) do
    local info = extras[name]
    if not info then
      Snacks.notify.warn('tokyonight.extra: unknown extra "' .. name .. '"')
    else
      local plugin = require('tokyonight.extra.' .. name)
      local fname
      if user_opts.location then
        fname = vim.fn.fnamemodify(user_opts.location, ':p')
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
      _write(fname, plugin.generate(colors, groups, opts))
    end
  end
end

return M
