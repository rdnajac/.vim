vim.g.transparent = true

---@module "tokyonight"
---@type tokyonight.Config
return {
  cache = true, -- default
  day_brightness = 0.3, -- default
  dim_inactive = true,
  light_style = 'day', -- default
  lualine_bold = false, -- default
  style = 'night',
  terminal_colors = true, -- default
  transparent = vim.g.transparent == true,
  styles = {
    comments = { italic = true },
    functions = {},
    keywords = { italic = false, bold = true },
    variables = { italic = false },
    floats = vim.g.transparent == true and 'transparent' or nil,
    sidebars = vim.g.transparent == true and 'transparent' or nil,
  },
  -- on_colors = function(colors) end,
  -- on_highlights = function(highlights, colors) end,
  -- plugins = { all = false },
}
