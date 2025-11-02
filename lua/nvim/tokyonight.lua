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

local mycolors = {
  blue = '#14afff',
  green = '#39ff14',
}

-- stylua: ignore
---@param colors ColorScheme
---@return tokyonight.Highlights
local myhighlights = function(colors)
  return {
    Normal        = vim.g.transparent and { bg = bg.black } or nil,
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
    vim.tbl_extend('force', colors, mycolors)
  end,
  on_highlights = function(hl, colors)
    vim.tbl_extend('force', hl, myhighlights(colors))
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
}
-- require('tokyonight').setup()

--- @type ColorScheme, tokyonight.Highlights, tokyonight.Config
M.colors, M.groups, M.opts = require('tokyonight').load(opts)
-- `load()` won't trigger ColorScheme autocommand, so do it here
vim.cmd.doautocmd({ '<nomodeline>', 'ColorScheme' })

-- write colors opts and grouos to a file: ~/.vim/tokyonight/debug/{colors,opts,groups}.lua
-- use nv.file.write
M.debug = function()
  local debug_dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'gen', 'tokyonight', 'debug')
  for _, fname in ipairs({ 'colors', 'groups', 'opts' }) do
    nv.file.write(vim.fs.joinpath(debug_dir, fname .. '.lua'), 'return ' .. vim.inspect(M[fname]))
  end
end

---@return string
function M.generate_vim_scheme()
  local opts = M.opts or {}
  opts.plugins = { all = false } -- disable plugins for scheme generation
  local colors, groups, _opts = require('tokyonight').load(opts)

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

  local function to_table(t, fn)
    local ret = {}
    for k, v in vim.spairs(t) do
      local result = fn(k, v)
      if result ~= nil then
        ret[#ret + 1] = result
      end
    end
    return ret
  end

  -- build highlight definitions and links
  local links = {}
  for name, hl in vim.spairs(groups) do
    if not vim.startswith(name, '@') then -- skip treesitter/semantic tokens
      if type(hl) == 'string' and not vim.startswith(hl, '@') then
        hl = { link = hl }
      end

      if hl.link then
        if groups[hl.link] then
          links[#links + 1] = ('hi! link %s %s'):format(name, hl.link)
        end
      elseif type(hl) == 'table' then
        local props = to_table(hl, function(k, v)
          if mapping[k] then
            return ('%s=%s'):format(mapping[k], v)
          end
        end)

        local gui = to_table(hl, function(k, v)
          if vim.tbl_contains(attrs, k) and v then
            return k
          end
        end)

        if #gui > 0 then
          props[#props + 1] = ('gui=%s'):format(table.concat(gui, ','))
        end

        if not hl.bg then
          props[#props + 1] = 'guibg=NONE'
        end

        if #props > 0 then
          lines[#lines + 1] = ('hi %s %s'):format(name, table.concat(props, ' '))
        else
          vim.schedule(function()
            vim.notify(
              ('tokyonight: invalid highlight group: %s'):format(name),
              vim.log.levels.WARN
            )
          end)
        end
      end
    end
  end

  -- add links at the end to ensure the original groups are defined
  vim.list_extend(lines, vim.list.unique(links))

  return table.concat(lines, '\n')
end

M.scheme = function()
  local write_dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'colors')
  local fname = vim.fs.joinpath(write_dir, 'tokyomidnight.vim')
  print('Writing ' .. fname)
  require('myfile').writefile(fname, M.generate_vim_scheme())
end

-- see ~/.local/share/nvim/site/pack/core/opt/tokyonight/lua/tokyonight/extra/
local want = {
  'ghostty',
  'lazygit',
  'lua', -- for debugging
  'slack',
  'spotify_player', -- TODO: fix the output; see template
  'vim',
}

M.build = function()
  local extras = require('tokyonight.extra').extras
  local style = 'midnight'
  local style_name
  local colors = M.colors
  local groups = M.groups
  local opts = M.opts
  local dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'gen', 'tokyonight')

  for _, name in ipairs(want) do
    local info = extras[name]
    if not info then
      error('tokyonight.extra: unknown extra "' .. name .. '"')
    end
    local plugin = require('tokyonight.extra.' .. name)
    if not plugin or not plugin.generate then
      error('tokyonight.extra.' .. name .. ' does not have a generate() function')
    end
    local fname = string
      .format(
        '%s/%s%s/tokyonight%s%s.%s',
        dir,
        name,
        info.subdir and '/' .. info.subdir .. '/' or '',
        info.sep or '_',
        style,
        info.ext
      )
      :gsub('%.$', '') -- remove trailing dot

    colors['_style_name'] = 'Tokyo Night' .. style_name
    colors['_name'] = 'tokyonight_' .. style
    colors['_style'] = style

    local content = plugin.generate(colors, groups, opts)
    print('Writing ' .. fname)
    require('myfile').writefile(fname, content)
  end
end

return M
