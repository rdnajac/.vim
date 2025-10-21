vim.g.transparent = true

local M = {
  'folke/tokyonight.nvim',
  --- @type ColorScheme
  colors = nil,
  --- @type tokyonight.Highlights
  groups = nil,
  --- @type tokyonight.Config
  opts = nil,
}

local bg = {
  black = '#000000',
  eigengrau = '#16161d',
  darkgrey = '#1f2335',
  tokyonight = '#24283b',
  lualine = '#3b4261',
}

local normal_bg = bg.black

local opts = {
  style = 'night',
  transparent = vim.g.transparent == true,

  styles = {
    comments = { italic = true },
    keywords = { italic = false, bold = true },
    -- variables = { italic = true },
    floats = vim.g.transparent == true and 'transparent' or nil,
    sidebars = vim.g.transparent == true and 'transparent' or nil,
  },
  dim_inactive = true,
  on_colors = function(colors)
    colors.blue = '#14afff'
    colors.green = '#39ff14'
  end,
  on_highlights = function(hl, colors)
    -- TODO:
    hl['Normal'] = (normal_bg and { bg = normal_bg }) or nil
    -- hl['LineNr'] = { fg = '#3B4261', bg = '#111111' }
    hl['Cmdline'] = { bg = bg.black }
    hl['Statement'] = { fg = colors.red }
    hl['Special'] = { fg = colors.red, bold = true }
    hl['SpellBad'] = { bg = colors.red }
    hl['WinBar'] = { bg = bg.lualine }
    hl['WinBorder'] = { bg = bg.lualine }
    hl['SpecialWindow'] = { bg = bg.eigengrau }
    hl['Green'] = { fg = colors.green }
    -- FIXME: check if this was interfering with something
    -- hl['RenderMarkdownCode'] = { bg = bg.tokyonight }
  end,
  plugins = {
    all = false,
    -- aerial = true,
    -- ale = true,
    -- dap = true,,
    -- flash = true,
    blink = true,
    mini = true,
    -- noice = true,
    ['render-markdown'] = true,
    sidekick = true,
    snacks = true,
    -- [ 'treesittr-contetxt' ] = true,
    trouble = true,
    ['which-key'] = true,
  },
}

M.config = function()
  -- optionally, run setup to cache colors and groups inside tokyonight module
  require('tokyonight').setup(opts)
  M.colors, M.groups = require('tokyonight').load(M.opts)
  -- `load()` does no trigger ColorScheme autocommands, so do it here
  vim.cmd.doautocmd({ '<nomodeline>', 'ColorScheme' })
end

---@param opts? tokyonight.Config
---@return string
function M.generate_vim_scheme(opts)
  local colors, groups = require('tokyonight').load(opts)

  local lines = {
    'hi clear',
    "let g:colors_name = 'tokyonight'",
  }

  local mapping = { fg = 'guifg', bg = 'guibg', sp = 'guisp' }
  local attrs = {
    'bold',
    'underline',
    'undercurl',
    'italic',
    'strikethrough',
    'underdouble',
    'underdotted',
    'underdashed',
    'inverse',
    'standout',
    'nocombine',
    'altfont',
  }

  local names = vim
    .iter(vim.tbl_keys(groups))
    :filter(function(n)
      return n:sub(1, 1) ~= '@' -- skip Treesitter/semantic tokens
    end)
    :totable()

  table.sort(names)

  -- build highlight definitions
  vim.iter(names):each(function(name)
    local hl = groups[name]
    if type(hl) == 'string' then
      hl = { link = hl }
    end
    if hl.link then
      return
    end

    local props = vim
      .iter(hl)
      :filter(function(k, _)
        return mapping[k] ~= nil
      end)
      :map(function(k, v)
        return ('%s=%s'):format(mapping[k], v)
      end)
      :totable()

    local gui = vim
      .iter(attrs)
      :filter(function(a)
        return hl[a] ~= nil
      end)
      :totable()

    if #gui > 0 then
      props[#props + 1] = ('gui=%s'):format(table.concat(gui, ','))
    end

    if not hl.bg then
      props[#props + 1] = 'guibg=NONE'
    end

    if #props > 0 then
      table.sort(props)
      lines[#lines + 1] = ('hi %s %s'):format(name, table.concat(props, ' '))
    else
      vim.schedule(function()
        vim.notify(('tokyonight: invalid highlight group: %s'):format(name), vim.log.levels.WARN)
      end)
    end
  end)

  -- build link lines and deduplicate
  local links = vim
    .iter(names)
    :map(function(name)
      local hl = groups[name]
      if type(hl) == 'string' then
        hl = { link = hl }
      end
      if hl.link and hl.link:sub(1, 1) ~= '@' and groups[hl.link] then
        return ('hi! link %s %s'):format(name, hl.link)
      end
    end)
    :filter(function(x)
      return x ~= nil
    end)
    :totable()

  vim.list_extend(lines, vim.list.unique(links))

  return table.concat(lines, '\n')
end

-- see ~/.local/share/nvim/site/pack/core/opt/tokyonight/lua/tokyonight/extra/
local want = {
  ghostty = '',
  lazygit = '',
  lua = '', -- for debugging
  slack = '',
  -- spotify_player = '~/.config/spotify-player/theme.toml',
  spotify_player = '', -- TODO: fix the output; see template
  vim = '',
  -- TODO: use the gen function in this module
}

local build = function()
  -- TODO: make sure config is loaded
  local extras = require('tokyonight.extra').extras
  local style = 'midnight'
  local style_name = ''
  -- local colors = M.colors
  -- local groups = M.groups
  -- local opts = M.opts
  local colors, groups = require('tokyonight').load(opts)
  local dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'tokyonight')

  for name, location in pairs(want) do
    local info = extras[name]
    if not info then
      error('tokyonight.extra: unknown extra "' .. name .. '"')
    else
      local plugin = require('tokyonight.extra.' .. name)
      local fname = name
        .. (info.subdir and '/' .. info.subdir .. '/' or '')
        .. '/tokyonight'
        .. (info.sep or '_')
        .. style
        .. '.'
        .. info.ext
      -- TODO: use string format

      -- FIXME:
      fname:gsub('%.$', '') -- remove trailing dot
      fname = vim.fs.joinpath(dir, fname)

      colors['_style_name'] = 'Tokyo Night' .. style_name
      colors['_name'] = 'tokyonight_' .. style
      colors['_style'] = style
      print('Writing ' .. fname)
      require('myfile').writefile(fname, plugin.generate(colors, groups, opts))
    end
  end
end

-- M.build = build

return M
