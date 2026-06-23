local colors = {
  black = '#16161d', -- eigengrau
  bg = '#1a1b26', -- night
  bg_dark = '#16161e', -- night
  bg_dark1 = '#0C0E14', -- night
  -- bg = "#24283b",       -- storm
  -- bg_dark = "#1f2335"   -- storm
  -- bg_dark1 = "#1b1e2d", -- storm
  bg_highlight = '#292e42',
  -- bg_statusline = '#3b4261' -- from lualine
  -- blue = '#14afff',
  blue = '#7aa2f7', -- orig
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
  -- green = '#9ece6a', -- orig
  green = '#39ff14',
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
  git = { add = '#449dab', change = '#6183bb', delete = '#914c54' },
  none = 'NONE',
}

-- stylua: ignore
local function hi() vim.cmd([[

" hi Function guifg=#ff9e64
hi String guifg=#39ff14
" Normal bg
hi NvimDarkGrey2 guifg=#16161d

]]) end

-- vim.cmd('hi Special guifg=' .. colors.red)
-- vim.cmd('hi NvimLightGrey2 guifg='..colors.fg) -- Normal fg
-- vim.cmd('hi Normal guibg=' .. colors.black) -- Normal bg
-- Normal = { bg = '#14161B', fg = '#E0E2EA' }

setmetatable(colors, { __call = hi })

return colors
