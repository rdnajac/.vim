local M = setmetatable({}, {
  __call = function(M, ...) return M.pos(...) end,
})

--- Normalize position arguments into a vim.Pos, falling back to cursor.
---@param ... any
---  - no args:       cursor position
---  - (row, col):    0-based integers → vim.pos(row, col)
---  - {row, col}:    extmark tuple (0-based) → vim.pos.extmark(arg)
---  - vim.Pos:       returned as-is
---@return vim.Pos
function M.pos(...)
  local nargs = select('#', ...)
  if nargs == 0 then
    return vim.pos.cursor(vim.api.nvim_win_get_cursor(0))
  elseif nargs == 2 then
    return vim.pos(...)
  elseif nargs == 1 then
    local arg = select(1, ...)
    if type(arg) == 'table' then
      if arg.row then
        return arg
      end -- already a vim.Pos
      return vim.pos.extmark(arg) -- {row, col} extmark tuple
    end
  end
  error('pos: invalid arguments')
end

return M
