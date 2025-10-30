vim.g.transparent = true

local M = {
  'folke/tokyonight.nvim',
}

local bg = {
  black = '#000000',
  eigengrau = '#16161d',
  darkgrey = '#1f2335',
  tokyonight = '#24283b',
  lualine = '#3b4261',
}

---@type ColorScheme
local mycolors = {
  blue = '#14afff',
  green = '#39ff14',
}

-- stylua: ignore
---@param colors ColorScheme
---@return tokyonight.Highlights
local myhighlights = function(colors)
  return {
    Normal        = { bg = bg.black },
    Cmdline       = { bg = bg.black },
    Statement     = { fg = colors.red },
    Special       = { fg = colors.red, bold = true },
    SpellBad      = { bg = colors.red },
    WinBar        = { bg = bg.lualine },
    WinBorder     = { bg = bg.lualine },
    SpecialWindow = { bg = bg.eigengrau },
  }
end

--- @type tokyonight.Config
require('tokyonight').setup({
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
    hl['Normal'] = (normal_bg and { bg = normal_bg }) or nil
    -- hl['LineNr'] = { fg = '#3B4261', bg = '#111111' }
    hl['Cmdline'] = { bg = bg.black }
    hl['Statement'] = { fg = colors.red }
    hl['Special'] = { fg = colors.red, bold = true }
    hl['SpellBad'] = { bg = colors.red }
    hl['WinBar'] = { bg = bg.lualine }
    hl['WinBorder'] = { bg = bg.lualine }
    hl['SpecialWindow'] = { bg = bg.eigengrau }
    -- hl['Green'] = { fg = colors.green }
    -- FIXME: check if this was interfering with something
    -- hl['RenderMarkdownCode'] = { bg = bg.tokyonight }
  end,
  -- TODO: check against vim.pack.get plugins
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
    ['treesitter-context'] = true,
    -- trouble = true,
    ['which-key'] = true,
  },
})

--- @type ColorScheme, tokyonight.Highlights, tokyonight.Config
M.colors, M.groups, M.opts = require('tokyonight').load()
-- `load()` won't trigger ColorScheme autocommand, so do it here
vim.cmd.doautocmd({ '<nomodeline>', 'ColorScheme' })

-- write colors opts and grouos to a file: ~/.vim/tokyonight/debug/{colors,opts,groups}.lua
-- use nv.file.write
M.debug = function()
  local debug_dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'tokyonight', 'debug')
  for _, fname in ipairs({ 'colors', 'groups', 'opts' }) do
    nv.file.write(vim.fs.joinpath(debug_dir, fname .. '.lua'), 'return ' .. vim.inspect(M[fname]))
  end
end

---@return string
function M.generate_vim_scheme()
  local groups = M.groups

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

  -- TODO: combine these?
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

M.build = function()
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
      require('myfile').writefile(fname, plugin.generate(colors, groups, opts))
    end
  end
end

return M
