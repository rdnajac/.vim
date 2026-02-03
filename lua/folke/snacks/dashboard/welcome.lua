local dijkstra = [[
The computing scientist's main challenge is not to 
get confused by the complexities of his own making.
]]

-- PERF: wrap in a function to defer requiring vim.version
local cmd = function()
  local version = 'NVIM ' .. tostring(vim.version())
  local fmt

  if vim.fn.executable('cowsay') == 1 then
    fmt = [[cowsay "%s"; printf "\n\t%s\n"]]
  else
    fmt = [[printf "\n%s\n\n\t%s\n"]]
  end

  local out = fmt:format(dijkstra, version)
  if vim.fn.executable('lolcat') == 1 then
    out = ('{ %s; } | lolcat'):format(out)
  end

  return out
end

return cmd
