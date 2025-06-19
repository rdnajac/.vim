local M = {}

function M.func(bang)
  local preserve_layout = bang == '' -- true if no '!'
  if #vim.fn.getbufinfo({ buflisted = 1 }) > 1 then
    if preserve_layout then
      Snacks.bufdelete()
    else
      vim.cmd('bdelete')
    end
  else
    vim.cmd('quit')
  end
end

return M
