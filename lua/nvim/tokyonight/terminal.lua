---@param color string  -- The hex color string to be adjusted
---@param lightness_amount number? -- The amount to increase lightness by (optional, default: 0.1)
---@param saturation_amount number? -- The amount to increase saturation by (optional, default: 0.15)
local function Brighten(color, lightness_amount, saturation_amount)
  lightness_amount = lightness_amount or 0.05
  saturation_amount = saturation_amount or 0.2
  local hsluv = require('tokyonight.hsluv')

  -- Convert the hex color to HSLuv
  local hsl = hsluv.hex_to_hsluv(color)

  -- Increase lightness slightly
  hsl[3] = math.min(hsl[3] + (lightness_amount * 100), 100)

  -- Increase saturation a bit more to make the color more vivid
  hsl[2] = math.min(hsl[2] + (saturation_amount * 100), 100)

  -- Convert the HSLuv back to hex and return
  return hsluv.hsluv_to_hex(hsl)
end

--- @return TerminalColors
local function terminal_colors(colors)
  -- stylua: ignore
  return {
    black          = colors.black,
    red            = colors.red,
    green          = colors.green,
    yellow         = colors.yellow,
    blue           = colors.blue,
    magenta        = colors.magenta,
    cyan           = colors.cyan,
    white          = colors.fg_dark,
    black_bright   = colors.terminal_black,
    red_bright     = Brighten(colors.red),
    green_bright   = Brighten(colors.green),
    yellow_bright  = Brighten(colors.yellow),
    blue_bright    = Brighten(colors.blue),
    magenta_bright = Brighten(colors.magenta),
    cyan_bright    = Brighten(colors.cyan),
    white_bright  = colors.fg,
  }
end

return terminal_colors
