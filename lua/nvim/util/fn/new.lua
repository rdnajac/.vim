-- edit a new file
-- promptt for input with vim.ui.input
local M = setmetatable({}, {
  __call = function(M, ...)
    return M.new(...)
  end,
})

-- FIXME:
function M.new(fname)
  vim.cmd.enew()
  if not nv.fn.is_nonempty_string(fname) then
    vim.ui.input({ prompt = 'edit file: ' }, function(input)
      vim.cmd.file(input)
    end)
  end
end

return M
