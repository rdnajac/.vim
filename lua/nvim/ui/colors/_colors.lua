local colors = require('nvim.ui.colors.palette')
-- Bg, Util.fg = colors.bg, colors.fg -- required to update utility function magic values
local Util = require('nvim.ui.colors.util')
local blend_bg = function(hex, amount, bg)
  return Util.blend(hex, amount, bg or colors.bg)
end
local blend_fg = function(hex, amount, fg)
  return Util.blend(hex, amount, fg or colors.fg)
end

colors.black = colors.black or blend_bg(colors.bg, 0.8, '#000000')
colors.border_highlight = blend_bg(colors.blue1, 0.8)
colors.border = colors.black

colors.diff = {
  add = blend_bg(colors.green2, 0.25),
  delete = blend_bg(colors.red1, 0.25),
  change = blend_bg(colors.blue7, 0.15),
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
colors.bg_visual = blend_bg(colors.blue0, 0.4)

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

local brighten = Util.brighten
-- stylua: ignore
colors.terminal = {
  black          = colors.black,
  red            = colors.red,
  green          = colors.green,
  yellow         = colors.yellow,
  blue           = colors.blue,
  magenta        = colors.magenta,
  cyan           = colors.cyan,
  white          = colors.fg_dark,
  black_bright   = colors.terminal_black,
  red_bright     = brighten(colors.red),
  green_bright   = brighten(colors.green),
  yellow_bright  = brighten(colors.yellow),
  blue_bright    = brighten(colors.blue),
  magenta_bright = brighten(colors.magenta),
  cyan_bright    = brighten(colors.cyan),
  white_bright  = colors.fg,
}

return colors
