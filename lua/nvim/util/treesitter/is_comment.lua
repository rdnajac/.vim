--- Check if the current node is a comment node
--- @param ... any
---   - no args: use cursor
---   - (int,int): row,col
---   - {int,int}: row,col
--- @return boolean
return function(...)
  local args = { ... }
  local pos

  if #args == 0 then
    local cursor = vim.api.nvim_win_get_cursor(0)
    pos = { cursor[1] - 1, cursor[2] }
  elseif #args == 1 and type(args[1]) == 'table' then
    pos = args[1]
  elseif #args == 2 and type(args[1]) == 'number' and type(args[2]) == 'number' then
    pos = { args[1], args[2] }
  elseif #args == 1 and type(args[1]) == 'number' then
    error('is_comment: single integer is ambiguous, expected {row,col}')
  else
    error('is_comment: invalid arguments')
  end

  local ok, node = pcall(vim.treesitter.get_node, { bufnr = 0, pos = pos })
  return ok
      and node
      and vim.tbl_contains({
        'comment',
        'line_comment',
        'block_comment',
        'comment_content',
      }, node:type())
    or false
end
