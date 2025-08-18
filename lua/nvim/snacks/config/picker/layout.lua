local borders = {
  left = { '', '', '', '', '', '', '', '│' },
  right = { '', '', '', '│', '', '', '', '' },
  top = { '', '─', '', '', '', '', '', '' },
  bottom = { '', '', '', '', '', '─', '', '' },
  hpad = { '', '', '', '    ', '', '', '', '   ' },
  vpad = { '', '    ', '', '', '', '   ', '', '' },
  topandbottom = { '', '─', '', '', '', '─', '', '' },
  leftandright = { '', '', '', '│', '', '', '', '│' },
  leftpad = { '', '', '', '', '', '', '', '▏' },
  topandleftpad = { ' ', '─', '', '', '', '', '', '▏' },
  topandleft = { '┬', '─', '', '', '', '', '', '│' },
}

---@module 'snacks'
---@type snacks.picker.layout.Config
return {
  preset = 'ivy',
  reverse = true,
  ---@type snacks.layout.Box[]
  layout = {
    box = 'vertical',
    row = vim.o.lines - math.floor(0.4 * vim.o.lines),
    height = 0.4,
    -- TODO: hide preview window if less than 120 cols
    {
      box = 'horizontal',
      -- border = borders.topandbottom,
      border = 'rounded',
      --  string or list where list consists of `[text, highlight]` tuples.
      {
        win = 'list',
        title = ' {title} {live} {flags}',
        title_pos = 'left',
        border = 'top',
      },
      {
        win = 'preview',
        border = borders.topandleft,
        width = 0.65,
        -- hide = function()
        --   return vim.o.columns < 120
        -- end,
      },
    },
    {
      win = 'input',
      height = 1,
      border = borders.leftandright,
    },
  },
}
