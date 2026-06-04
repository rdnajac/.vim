local borders = {
  left = { '', '', '', '', '', '', '', '│' },
  leftpad = { '', '', '', '', '', '', '', '▏' },
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

-- TODO: box-drawing util
