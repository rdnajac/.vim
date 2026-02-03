local dijkstra = [[
"The computing scientist's main challenge is not to get
confused by the complexities of his own making."
]]

-- PERF: wrap in a function to defer requiring vim.version
local cmd = function()
  local version = 'NVIM ' .. tostring(vim.version())
  if vim.fn.executable('cowsay') == 0 or vim.fn.executable('lolcat') == 0 then
    return ([[echo "%s\n\t%s"]]):format(dijkstra, version)
  end
  return ([[{ cowsay %s; printf "\n\t%s\n"; } | lolcat ]]):format(dijkstra, version)
end

return cmd
