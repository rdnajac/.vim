--- Returns the file path of the first non-self caller.
---@return string|nil
local M = function()
  local self_path = debug.getinfo(1, 'S').source:sub(2)
  local self_dir = vim.fn.fnamemodify(self_path, ':h')

  local i = 2
  while true do
    local info = debug.getinfo(i, 'S')
    if not info then
      return nil
    end

    local src = info.source
    if src:sub(1, 1) == '@' then
      local abs = vim.fn.fnamemodify(src:sub(2), ':p')
      if not vim.startswith(abs, self_dir) then
        return abs
      end
    end
    i = i + 1
  end
end

return M
