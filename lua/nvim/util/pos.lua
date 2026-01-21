local M = setmetatable({}, {
  __call = function(M, ...) return M.pos(...) end,
})

--- Parse position arguments into a vim.pos object
--- @param ... any
---   - no args: use cursor
---   - (int,int): row,col
---   - {int,int}: row,col
--- @return vim.pos
function M.pos(...)
  local nargs = select('#', ...)
  local pos

  if nargs == 0 then
    pos = vim.pos.cursor(vim.api.nvim_win_get_cursor(0))
  elseif nargs == 1 then
    local arg = select(1, ...)
    if type(arg) == 'table' then
      pos = vim.pos.extmark(arg)
    else
      error('get_pos: single integer is ambiguous, expected {row,col}')
    end
  elseif nargs == 2 then
    pos = vim.pos(...)
  else
    error('get_pos: invalid arguments')
  end

  return pos
end

return M
