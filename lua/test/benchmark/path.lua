local function bench(label, fn)
  local start = vim.loop.hrtime()
  for _ = 1, 1000 do
    fn()
  end
  local elapsed = (vim.loop.hrtime() - start) / 1e6
  print(label, string.format('%.2f ms', elapsed))
end

local dir = vim.fs.joinpath(vim.g.stdpath.config, 'lua', 'nvim', 'plugins')
local files = vim.fn.globpath(dir, '[^i]*.lua', false, true)
local base = vim.fs.joinpath(vim.g.stdpath.config, 'lua')

for _, path in ipairs(files) do
  bench('match', function()
    local name = path:match('lua/(.-)%.lua$')
    return name
  end)

  bench('sub', function()
    local rel = path:sub(#base + 2, -5) -- skip leading slash, strip .lua
    return rel
  end)

  bench('fnamemodify', function()
    local name = vim.fn.fnamemodify(path, ':r:s?.*/lua/??')
    return name
  end)

  bench('relpath', function()
    local rel = vim.fs.relpath(base, path)
    return rel:sub(1, -5) -- strip .lua
  end)

  break -- remove to test all files
end
