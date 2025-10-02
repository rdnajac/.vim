local paths = {}
for i = 1, 1e5 do
  paths[i] = 'user/repo' .. i -- valid GitHub-style
end

local function bench(label, fn)
  local start = vim.loop.hrtime()
  for i = 1, #paths do
    fn(paths[i])
  end
  local elapsed = (vim.loop.hrtime() - start) / 1e6
  print(label, string.format('%.2f ms', elapsed))
end

local gh = function(s)
  return s:match('^[%w._-]+/[%w._-]+$') and 'https://github.com/' .. s .. '.git' or s
end

local gh_unsage = function(s)
  return 'https://github.com/' .. s .. '.git'
end

bench('gh safe', gh)
bench('gh unsafe', gh_unsage)
