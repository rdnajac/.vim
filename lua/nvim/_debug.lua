local i = 0
local j = 0
nv.for_each_submodule('nvim', 'plugins', function(m, n)
  i = i + 1
  print(i .. ' | ' .. n)
  local speclist = vim.islist(m) and m or { m }
  for _, spec in ipairs(speclist) do
    if type(spec) == 'table' and spec[1] then
      j = j + 1
      print(j .. ' | ' .. spec[1])
    end
  end
end)
