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
    -- ale = true,
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

M.load = function()
  vim.pack.add(vim.tbl_map(function(s)
    return 'https://github.com/' .. s
  end, M.specs))
  require('tokyonight').load(M.opts)
end

---@param file string
---@param contents string
local function _write(file, contents)
  vim.fn.mkdir(vim.fn.fnamemodify(file, ':h'), 'p')
  local fd = assert(io.open(file, 'w+'))
  fd:write(contents)
  fd:close()
end

local extras = {
  -- fzf = { ext = 'sh', url = 'https://github.com/junegunn/fzf', label = 'Fzf' },
  ghostty = { ext = '', url = 'https://github.com/ghostty-org/ghostty', label = 'Ghostty' },
  lazygit = { ext = 'yml', url = 'https://github.com/jesseduffield/lazygit', label = 'Lazygit' },
  lua = { ext = 'lua', url = 'https://www.lua.org', label = 'Lua Table for testing' },
  prism = { ext = 'js', url = 'https://prismjs.com', label = 'Prism' },
  slack = { ext = 'txt', url = 'https://slack.com', label = 'Slack' },
  spotify_player = { ext = 'toml', url = 'https://github.com/aome510/spotify-player', label = 'Spotify Player' },
  tmux = { ext = 'tmux', url = 'https://github.com/tmux/tmux/wiki', label = 'Tmux' },
  vim = { ext = 'vim', url = 'https://vimhelp.org/', label = 'Vim', subdir = 'colors', sep = '-' },
}

local location = {
  spotify_player = '~/.config/spotify-player/theme.toml',
}

M.build = function()
  local style = 'midnight'
  local style_name = ''
  for _, extra in ipairs(vim.tbl_keys(extras)) do
    local info = extras[extra]
    local plugin = require('tokyonight.extra.' .. extra)
    local colors, groups, opts = require('tokyonight').load(M.opts)

    local fname
    if location[extra] then
      fname = vim.fn.fnamemodify(location[extra], ':p')
    else
      fname = extra
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

return M
