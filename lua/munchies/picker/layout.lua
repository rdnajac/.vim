---@type snacks.layout.Config
return {
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
      {
        win = 'list',
        title = ' {title} {live} {flags}',
        title_pos = 'left',
        -- border = borders.toppad,
      },
      {
        win = 'preview',
        title = '{preview:Preview}',
        title_pos = 'left',
        -- border = borders.toppad,
        width = 0.6,
        wo = { number = false },
        -- todo: hide preview window if less than 120 cols
      },
    },
    {
      win = 'input',
      height = 1,
      -- border = nv.ui.border(left, borders.right),
    },
  },
}
