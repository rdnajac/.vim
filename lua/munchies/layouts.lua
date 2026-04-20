local M = {}

-- pop-up for selecting text in insert mode
-- layout = require(
M.insert = {
  hidden = { 'preview' },
  layout = {
    reverse = true,
    backdrop = false,
    relative = 'cursor',
    row = 1,
    width = 0.3,
    min_width = 48,
    height = 0.3,
    border = 'none',
    box = 'vertical',
    { win = 'input', height = 1, border = 'rounded', wo = { cursorline = false } },
    { win = 'list', border = 'rounded' },
    { win = 'preview', border = 'rounded', title = '{preview:Preview}' },
  },
}

M.mylayout = {
  preset = 'ivy',
  reverse = true,
  ---@type snacks.layout.Box[]
  layout = {
    box = 'vertical',
    row = vim.o.lines - math.floor(0.4 * vim.o.lines),
    height = 0.4,
    {
      box = 'horizontal',
      border = 'rounded',
      title = ' {title} {live} {flags}',
      title_pos = 'left',
      {
        win = 'list',
        border = 'top',
      },
      {
        win = 'preview',
        border = 'top',
        title = '{preview:Preview}',
        -- title = '{title}',
        title_pos = 'right',
        width = 0.6,
        wo = { number = false },
      },
    },
    { win = 'input', height = 1 },
  },
}

return M
