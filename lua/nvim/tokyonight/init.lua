local M = {}

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
    Normal = vim.g.transparent ~= true and { bg = c.black } or nil,
    -- Function = { fg = c.blue },
    Number = { fg = c.blue },
    Special = { fg = c.red, bold = true },
    SpellBad = { bg = c.red },
    Statement = { fg = c.red },
    StatusLine = { bg = 'NONE' },
    -- lsp
    -- ['@property'] = { fg = c.yellow },
    -- ['@keyword.function'] = { fg = c.red },
    -- ['@variable.parameter'] = { fg = c.magenta },
    -- ['@variable.member'] = { fg = c.blue },
  }
end

vim.g.transparent = true

---@return tokyonight.Config
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
  plugins = {
    all = false,
    -- mini = true,
  },
}

-- ~/.local/share/nvim/site/pack/core/opt/tokyonight.nvim/lua/tokyonight/groups/
local function extend_opts_plugins()
  for plugin, group in pairs(require('tokyonight.groups').plugins) do
    if vim.fn.isdirectory(vim.g.plug_home .. '/' .. plugin) ~= 0 then
      opts.plugins[group] = true
    end
  end

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
    -- 'operators',
    -- 'pick',
    -- 'starter',
    -- 'statusline',
    'surround',
    -- 'tabline',
    -- 'test',
    -- 'trailspace',
  }) do
    opts.plugins['mini_' .. mod] = true
  end
end

M.init = function()
  extend_opts_plugins()
  -- require('tokyonight').setup(opts)
  --- @type ColorScheme, tokyonight.Highlights, tokyonight.Config
  M.colors, M.groups, M.opts = require('tokyonight').load(opts)
  -- `load()` won't trigger ColorScheme autocommand, so do it here
  vim.cmd.doautocmd({ '<nomodeline>', 'ColorScheme' })
end

M.debug = function()
  local this_file = debug.getinfo(1, 'S').source:sub(2)
  local this_dir = vim.fs.abspath(vim.fs.dirname(this_file))
  print('Writing debug files to: ' .. this_dir)
  for _, name in ipairs({ 'colors', 'groups', 'opts' }) do
    local t, fname = M[name], vim.fs.joinpath(this_dir, 'gen', name .. '.json')

    local i = 1
    if name == 'opts' then
      -- go though the table and replace functions with the string <function %d> and count inside theat func
      local function replace_functions(tbl)
        for k, v in pairs(tbl) do
          if type(v) == 'function' then
            tbl[k] = '<function ' .. i .. '>'
            i = i + 1
          elseif type(v) == 'table' then
            replace_functions(v)
          end
        end
      end
      replace_functions(t)
    end
    -- nv.file.write(vim.fs.joinpath(this_dir, 'gen', name .. '.lua'), 'return ' .. vim.inspect(M[name]))
    nv.json.write(fname, t)
  end
end

return M
