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
    hl['RenderMarkdownCode'] = { bg = bg.tokyonight }
  end,
  plugins = {
    all = false,
    -- ale = true
    blink = true,
    mini = true,
    -- noice = true,
    snacks = true,
    -- trouble = true
    ['render-markdown'] = true,
    ['which-key'] = true,
  },
}

M.colors = {}
M.groups = {}

M.config = function()
  -- set up once to cache the user opts
  require('tokyonight').setup(M.opts)
  -- load sets the color scheme and returns useful tables
  local colors, groups, opts = require('tokyonight').load()
  M.colors = colors
  M.groups = groups
end

--- @param colors ColorScheme
--- @param groups tokyonight.Highlights
--- @param opts tokyonight.Config
function M.generate_vim_scheme()
  M.config() -- PERF: I shouldn't have to call this a second time...
  -- M.colors/groups not ready an func def
  local colors = M.colors
  local groups = M.groups

  if not colors or not groups then
    error('M.colors or M.groups not loaded. Did you call M.config() first?')
  end

  local lines = {
    [[
      hi clear
      let g:colors_name = "tokyonight"
    ]],
    -- :format(colors._style),
  }

  local names = vim.tbl_filter(function(group)
    -- filter out treesitter/semantic token highlights
    -- PERF: also filter out vim plugins
    return group:sub(1, 1) ~= '@'
  end, vim.tbl_keys(groups))

  table.sort(names)

  local used = {}
  for _, name in ipairs(names) do
    local hl = groups[name]
    if type(hl) == 'string' then
      hl = { link = hl }
    end

    if not hl.link then
      local props = {}
      local mapping = {
        fg = 'guifg',
        bg = 'guibg',
        sp = 'guisp',
      }

      -- fg/bg/sp
      for k, v in pairs(hl) do
        if mapping[k] then
          props[#props + 1] = ('%s=%s'):format(mapping[k], v)
        end
      end

      -- gui
      local gui = {}

      for _, attr in ipairs({
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
      }) do
        if hl[attr] then
          gui[#gui + 1] = attr
        end
      end
      if #gui > 0 then
        props[#props + 1] = ('gui=%s'):format(table.concat(gui, ','))
      end

      if #props > 0 then
        if not hl.bg then
          props[#props + 1] = 'guibg=NONE'
        end
        table.sort(props)
        used[name] = true
        lines[#lines + 1] = ('hi %s %s'):format(name, table.concat(props, ' '))
      else
        print('tokyonight: invalid highlight group: ' .. name)
      end
    end
  end

  for _, name in ipairs(names) do
    local hl = groups[name]
    if type(hl) == 'string' then
      hl = { link = hl }
    end

    if hl.link then
      if hl.link:sub(1, 1) ~= '@' and groups[hl.link] and used[hl.link] then
        lines[#lines + 1] = ('hi! link %s %s'):format(name, hl.link)
      end
    end
  end

  return table.concat(lines, '\n')
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
  ghostty = '',
  lazygit = '',
  lua = '', -- for debugging
  slack = '',
  -- spotify_player = '~/.config/spotify-player/theme.toml',
  spotify_player = '',
  vim = '',
  -- TODO: use the gen function in this module
}

M.build = function()
  -- TODO: make sure config is loaded
  local extras = require('tokyonight.extra').extras
  local style = 'midnight'
  local style_name = ''
  local colors = M.colors
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

      colors['_style_name'] = 'Tokyo Night' .. style_name
      colors['_name'] = 'tokyonight_' .. style
      colors['_style'] = style
      print('Writing ' .. fname)
      -- _write(fname, plugin.generate(colors, M.groups, M.opts))
      -- TODO:  add luals
      _write(fname, plugin.generate(require('tokyonight').load()))
    end
  end
end

return M
