local M = {}

M.unloaded = function()
  local names = {}
  for _, p in ipairs(vim.pack.get()) do
    if not p.active then
      names[#names + 1] = p.spec.name
    end
  end
  return names
end

return M
