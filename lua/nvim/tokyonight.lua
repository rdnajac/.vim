local M = { 'folke/tokyonight.nvim' }

local bg = {
  black = '#000000',
  eigengrau = '#16161d',
  darkgrey = '#1f2335',
  tokyonight = '#24283b',
  lualine = '#3b4261',
}
vim.g.transparent = true

--- @type ColorScheme
M.colors = nil
--- @type tokyonight.Highlights
M.groups = nil
--- @type tokyonight.Config
M.opts = {
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
    -- hl['Normal'] = { bg = bg.eigengrau }
    -- hl['LineNr'] = { fg = '#3B4261', bg = '#111111' }
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
    mini = true,
    -- noice = true,
    ['render-markdown'] = true,
    snacks = true,
    trouble = true,
    ['which-key'] = true,
  },
}

-- TODO: keep all ui stuff here?
M.after = function()
  vim.cmd.colorscheme('tokyonight')
end

-- FIXME: this function is cached on the first require and
-- doesn't see changes to M.colors or M.groups
function M.generate_vim_scheme()
  M.colors, M.groups, _ = require('tokyonight').load()
  local colors = M.colors
  local groups = M.groups
  local lines = {
    [[
      hi clear
      let g:colors_name = 'tokyonight'
    ]],
    -- :format(colors._style),
  }
  local names = vim.tbl_filter(function(group)
    -- filter out treesitter/semantic token highlights
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
      -- TODO: try this
      -- local props = vim.tbl_map(function(k)
      --   return ('%s=%s'):format(mapping[k], hl[k])
      -- end,
      -- vim.tbl_filter(function(k) return mapping[k] ~= nil end, vim.tbl_keys(hl)))
      --

      -- TODO: or this!
      -- local props = vim
      --   .iter(hl)
      --   :filter(function(k, _v)
      --     return mapping[k] ~= nil
      --   end)
      --   :map(function(k, v)
      --     return ('%s=%s'):format(mapping[k], v)
      --   end)
      --   :totable()

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

M.build = function()
  -- TODO: make sure config is loaded
  local extras = require('tokyonight.extra').extras
  local style = 'midnight'
  local style_name = ''
  local colors = M.colors
  local groups = M.groups
  local opts = M.opts
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
      _write(fname, plugin.generate(colors, groups, opts))
    end
  end
end

return M
