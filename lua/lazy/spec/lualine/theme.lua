-- local M = require('lualine.themes.auto')
M = {
  command = {
    a = { bg = '#e0af68', fg = '#15161e' },
    b = { bg = '#3b4261', fg = '#e0af68' },
  },
  inactive = {
    a = { bg = '#16161e', fg = '#14afff' },
    b = { bg = '#16161e', fg = '#3b4261', gui = 'bold' },
    c = { bg = 'NONE', fg = '#3b4261' },
  },
  insert = {
    a = { bg = '#39ff14', fg = '#15161e' },
    b = { bg = '#3b4261', fg = '#39ff14' },
  },
  normal = {
    a = { bg = '#14afff', fg = '#15161e' },
    b = { bg = '#3b4261', fg = '#14afff', gui = 'bold' },
    c = { bg = 'NONE', fg = 'NONE' },
    x = { bg = '#14afff', fg = 'NONE' },
    y = { bg = '#3b4261', fg = '#14afff', gui = 'bold' },
    z = { bg = 'NONE', fg = '#14afff', gui = 'bold' },
  },
  replace = {
    a = { bg = '#f7768e', fg = '#15161e' },
    b = { bg = '#3b4261', fg = '#f7768e' },
  },
  terminal = {
    a = { bg = '#73daca', fg = '#15161e' },
    b = { bg = '#3b4261', fg = '#73daca' },
  },
  visual = {
    a = { bg = '#bb9af7', fg = '#15161e' },
    b = { bg = '#3b4261', fg = '#bb9af7' },
  },
}

return M
