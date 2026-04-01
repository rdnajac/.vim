---@module "tokyonight"

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

---@type tokyonight.Config
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
  -- plugins = { all = false },
}

return opts
