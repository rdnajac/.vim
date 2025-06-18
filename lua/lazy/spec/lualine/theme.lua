-- originally generated from `require('lualine.themes.auto')`
-- with tokyonight.nvim as current colorscheme
local color = {
  command = '#e0af68',
  insert = '#39ff14',
  normal = '#14aeff',
  replace = '#f7768e',
  terminal = '#73daca',
  visual = '#bb9af7',
}
-- local black = ''#16161e'
local black = '#000000'

local grey = '#3b4261'

-- stylua: ignore
M = {}

M.normal = {
  a = { bg = color.normal, fg = black, gui = 'bold' },
  b = { bg = grey, fg = color.normal, gui = 'bold' },
  c = { bg = 'NONE', fg = color.normal },
  x = { bg = color.normal, fg = 'NONE' },
  y = { bg = grey, fg = color.normal, gui = 'bold' },
  z = { fg = color.normal, bg = 'NONE', gui = 'bold' },
}

for mode, col in pairs(color) do
  M[mode] = {
    a = { bg = col, fg = black, gui = 'bold' },
    b = { bg = grey, fg = col, gui = 'bold' },
    c = { bg = 'NONE', fg = col },
    z = { bg = 'NONE', fg = col, gui = 'bold' },
  }
end

M.inactive = {
  a = { bg = 'NONE', fg = color.insert, gui = 'bold' },
  -- b = { bg = '#16161e', fg = grey, gui = 'bold' },
  -- c = { bg = 'NONE', fg = grey },
  z = { fg = color.insert, bg = 'NONE', gui = 'bold' },
}

return M
