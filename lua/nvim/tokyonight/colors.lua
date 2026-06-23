local colors = {
  black = '#16161d', -- eigengrau
  bg = '#1a1b26', -- night
  bg_dark = '#16161e', -- night
  bg_dark1 = '#0C0E14', -- night
  -- bg = "#24283b",       -- storm
  -- bg_dark = "#1f2335"   -- storm
  -- bg_dark1 = "#1b1e2d", -- storm
  bg_highlight = '#292e42',
  -- bg_lualine = '#3b4261' -- lualine default
  --blue = '#14afff',
  blue = '#7aa2f7',
  blue0 = '#3d59a1',
  blue1 = '#2ac3de',
  blue2 = '#0db9d7',
  blue5 = '#89ddff',
  blue6 = '#b4f9f8',
  blue7 = '#394b70',
  comment = '#565f89',
  cyan = '#7dcfff',
  dark3 = '#545c7e',
  dark5 = '#737aa2',
  fg = '#c0caf5',
  fg_dark = '#a9b1d6',
  fg_gutter = '#3b4261',
  -- green = '#39ff14',
  green = '#9ece6a',
  green1 = '#73daca',
  green2 = '#41a6b5',
  magenta = '#bb9af7',
  magenta2 = '#ff007c',
  orange = '#ff9e64',
  purple = '#9d7cd8',
  red = '#f7768e',
  red1 = '#db4b4b',
  teal = '#1abc9c',
  terminal_black = '#414868',
  yellow = '#e0af68',
  git = {
    add = '#449dab',
    change = '#6183bb',
    delete = '#914c54',
  },
  none = 'NONE',
}

---@param foreground string foreground color
---@param background string background color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
local blend = function(foreground, alpha, background)
  alpha = type(alpha) == 'string' and (tonumber(alpha, 16) / 0xff) or alpha

  local function rgb(c)
    c = string.lower(c)
    return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
  end

  local bg = rgb(background)
  local fg = rgb(foreground)

  local blendChannel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format('#%02x%02x%02x', blendChannel(1), blendChannel(2), blendChannel(3))
end

-- Bg, Util.fg = colors.bg, colors.fg -- required to update utility function magic values
Blend_bg = function(hex, amount, bg) return blend(hex, amount, bg or colors.bg) end
Blend_fg = function(hex, amount, fg) return blend(hex, amount, fg or colors.fg) end

colors.black = colors.black or Blend_bg(colors.bg, 0.8, '#000000')
colors.border_highlight = Blend_bg(colors.blue1, 0.8)
colors.border = colors.black

colors.diff = {
  add = Blend_bg(colors.green2, 0.25),
  delete = Blend_bg(colors.red1, 0.25),
  change = Blend_bg(colors.blue7, 0.15),
  text = colors.blue7,
}

colors.fg_float = colors.fg
colors.bg_float = colors.bg_dark
-- colors.bg_float = opts.transparent and colors.none or colors.bg_dark

colors.fg_sidebar = colors.fg_dark
colors.bg_sidebar = colors.bg_dark
-- colors.bg_sidebar = opts.transparent and colors.none or colors.bg_dark

colors.bg_popup = colors.bg_dark
colors.bg_statusline = colors.bg_dark

colors.bg_search = colors.blue0
colors.bg_visual = Blend_bg(colors.blue0, 0.4)

colors.error = colors.red1
colors.hint = colors.teal
colors.info = colors.blue2
colors.todo = colors.blue
colors.warning = colors.yellow

colors.rainbow = {
  colors.blue,
  colors.yellow,
  colors.green,
  colors.teal,
  colors.magenta,
  colors.purple,
  colors.orange,
  colors.red,
}

colors.terminal = require('nvim.tokyonight.terminal')(colors)

return {
  colors = colors,
  Blend_bg = Blend_bg,
  Blend_fg = Blend_fg,
}
