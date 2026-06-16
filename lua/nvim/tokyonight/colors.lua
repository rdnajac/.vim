return {
  ---@param opts tokyonight.Config
  setup = function(opts)
    local Util = require('tokyonight.util')
    local colors = require('nvim.tokyonight.palette')
    Util.bg, Util.bf = colors.bg, colors.bg
    Util.day_brightness = opts.day_brightness

    -- colors.black = '#000000'
    colors.black = Util.blend_bg(colors.bg, 0.8, '#000000')
    colors.border_highlight = Util.blend_bg(colors.blue1, 0.8)
    colors.border = colors.black
    colors.none = 'NONE'
    -- colors.blue = '#14afff'
    -- colors.green = '#39ff14' -- orig: #9ece6a

    colors.diff = {
      add = Util.blend_bg(colors.green2, 0.25),
      delete = Util.blend_bg(colors.red1, 0.25),
      change = Util.blend_bg(colors.blue7, 0.15),
      text = colors.blue7,
    }

    colors.git.ignore = colors.dark3

    -- Popups and statusline always get a dark background
    colors.bg_popup = colors.bg_dark
    colors.bg_statusline = colors.bg_dark

    -- Sidebar and Floats are configurable
    colors.bg_sidebar = opts.styles.sidebars == 'transparent' and colors.none
      or opts.styles.sidebars == 'dark' and colors.bg_dark
      or colors.bg

    colors.bg_float = opts.styles.floats == 'transparent' and colors.none
      or opts.styles.floats == 'dark' and colors.bg_dark
      or colors.bg

    colors.bg_search = colors.blue0
    colors.bg_visual = Util.blend_bg(colors.blue0, 0.4)
    colors.fg_float = colors.fg
    colors.fg_sidebar = colors.fg_dark

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

    -- stylua: ignore
    --- @class TerminalColors
    colors.terminal = {
      black          = colors.black,
      black_bright   = colors.terminal_black,
      red            = colors.red,
      red_bright     = Util.brighten(colors.red),
      green          = colors.green,
      green_bright   = Util.brighten(colors.green),
      yellow         = colors.yellow,
      yellow_bright  = Util.brighten(colors.yellow),
      blue           = colors.blue,
      blue_bright    = Util.brighten(colors.blue),
      magenta        = colors.magenta,
      magenta_bright = Util.brighten(colors.magenta),
      cyan           = colors.cyan,
      cyan_bright    = Util.brighten(colors.cyan),
      white          = colors.fg_dark,
      white_bright   = colors.fg,
    }
    return colors, opts
  end,
}
