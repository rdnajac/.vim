local dijkstra = [[
The computing scientist's main challenge is not to 
get confused by the complexities of his own making.
]]

local function version() return ('NVIM %s'):format(tostring(vim.version())) end

return function()
  local fmt
  if vim.fn.executable('cowsay') == 1 then
    fmt = [[cowsay "%s"; printf "\n\t%s\n"]]
  else
    fmt = [[printf "\n%s\n\n\t%s\n"]]
  end

  local out = fmt:format(dijkstra, version())
  -- if vim.fn.executable('lolcat') == 1 then
  --   out = ('{ %s; } | lolcat'):format(out)
  -- end
  return out
  -- "(printf '%%s\\n\\n' %s; printf '%%s\\n\\n' %s; cowsay %s; printf '\\n\\t%%s\\n' %s) | lolcat",
  -- vim.fn.shellescape(header),
  -- vim.fn.shellescape(get_keys()),
  -- vim.fn.shellescape(dijkstra),
  -- vim.fn.shellescape(version())
end
