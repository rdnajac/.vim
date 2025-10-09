local paths = {}
for i = 1, 1e5 do
  paths[i] = '/some/very/long/path/to/file' .. i .. '.lua'
end

local function bench(label, fn)
  local start = vim.loop.hrtime()
  for i = 1, #paths do
    fn(paths[i])
  end
  local elapsed = (vim.loop.hrtime() - start) / 1e6
  print(label, string.format('%.2f ms', elapsed))
end

bench('match %.lua$', function(path)
  return path:match('^.+/(.+)%.lua$')
end)

bench('match + sub', function(path)
  return path:match('^.+/(.+)'):sub(1, -5)
end)
