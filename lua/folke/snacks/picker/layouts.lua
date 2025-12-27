local borders = {
  left = { '', '', '', '', '', '', '', '│' },
  leftpad = { '', '', '', '', '', '', '', '▏' }, -- TODO: modifier for left/right pad
  right = { '', '', '', '│', '', '', '', '' },
  top = { '', '─', '', '', '', '', '', '' },
  toppad = { '', ' ', '', '', '', '', '', '' },
  bottom = { '', '', '', '', '', '─', '', '' },
  -- hpad = { '', '', '', '    ', '', '', '', '   ' },
  -- vpad = { '', '   ', '', '', '', '   ', '', '' },
  single = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
  double = { '╔', '═', '╗', '║', '╝', '═', '╚', '║' },
  rounded = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
}

---@param b1 string[]
---@param b2 string[]
---@return string[]
local function combine(b1, b2)
  assert(#b1 == 8 and #b2 == 8, 'borders must be length 8')
  local res = {}
  for i = 1, 8 do
    local v2 = b2[i]
    res[i] = (v2 ~= '' and v2) or b1[i]
  end
  return res
end

---@type table<string, snacks.picker.layout.Config>
local M = {}

---@module 'snacks'
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
      {
        win = 'list',
        title = ' {title} {live} {flags}',
        title_pos = 'left',
        border = borders.toppad,
      },
      {
        win = 'preview',
        title = '{preview:Preview}',
        title_pos = 'left',
        border = borders.toppad,
        width = 0.6,
        wo = { number = false },
        -- todo: hide preview window if less than 120 cols
      },
    },
    {
      win = 'input',
      height = 1,
      border = combine(borders.left, borders.right),
    },
  },
}

M.insert = {
  layout = {
    reverse = true,
    relative = 'cursor',
    row = 1,
    width = 0.3,
    min_width = 48,
    height = 0.3,
    border = 'none',
    box = 'vertical',
    { win = 'input', height = 1, border = 'rounded', wo = { cursorline = false } },
    { win = 'list', border = 'rounded' },
  },
}

return M
