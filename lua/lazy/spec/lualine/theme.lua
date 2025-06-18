-- local M = require('lualine.themes.auto')
M = {
  command = {
    a = { bg = '#e0af68', fg = '#15161e' },
    b = { bg = '#3b4261', fg = '' },
    z = { fg = '#e0af68', bg = 'NONE', gui = 'bold' },
  },
  inactive = {
    a = { bg = '#16161e', fg = '#14afff' },
    b = { bg = '#16161e', fg = '#3b4261', gui = 'bold' },
    c = { bg = 'NONE', fg = '#3b4261' },
    z = { fg = '#14afff', bg = 'NONE', gui = 'bold' },
  },
  insert = {
    a = { bg = '#39ff14', fg = '#15161e' },
    b = { bg = '#3b4261', fg = '#39ff14' },
    z = { fg = '#39ff14', bg = 'NONE', gui = 'bold' },
  },
  normal = {
    a = { bg = '#14afff', fg = '#15161e' },
    b = { bg = '#3b4261', fg = '#14afff', gui = 'bold' },
    c = { bg = 'NONE', fg = 'NONE' },
    x = { bg = '#14afff', fg = 'NONE' },
    y = { bg = '#3b4261', fg = '#14afff', gui = 'bold' },
    z = { fg = '#14afff', bg = 'NONE', gui = 'bold' },
  },
  replace = {
    a = { bg = '#f7768e', fg = '#15161e' },
    b = { bg = '#3b4261', fg = '#f7768e' },
    z = { fg = '#f7768e', bg = 'NONE', gui = 'bold' },
  },
  terminal = {
    a = { bg = '#73daca', fg = '#15161e' },
    b = { bg = '#3b4261', fg = '#73daca' },
    z = { fg = '##73daca', bg = 'NONE', gui = 'bold' },
  },
  visual = {
    a = { bg = '#bb9af7', fg = '#15161e' },
    b = { bg = '#3b4261', fg = '#bb9af7' },
    z = { fg = '#bb9af7', bg = 'NONE', gui = 'bold' },
  },
}

return M
