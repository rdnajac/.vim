local paths = {}
for i = 1, 5e4 do
  paths[i] = '/some/very/long/path/to/plugin_' .. i .. '_abcdefghi/init.lua'
end

-- build 50 random plugin names of varying lengths
local plugins = {}
for i = 1, 50 do
  local name = 'plugin_' .. i .. string.rep('x', (i % 10) + 1)
  plugins[i] = name
end

local function bench(label, fn)
  local start = vim.loop.hrtime()
  for i = 1, #paths do
    fn(paths[i])
  end
  local elapsed = (vim.loop.hrtime() - start) / 1e6
  print(label, string.format('%.2f ms', elapsed))
end

-- common preprocessing, per your rule
local function preprocess(name)
  return name:gsub('%.nvim$', ''):lower()
end

bench('list lookup lower (50 items)', function(path)
  local name = path:match('^.+/(.+)/init%.lua$')
  if not name then
    return
  end
  local modname = preprocess(name)
  for _, plug in ipairs(plugins) do
    if modname == plug then
      return true
    end
  end
end)

bench('list lookup direct (50 items)', function(path)
  local name = path:match('^.+/(.+)/init%.lua$')
  if not name then
    return
  end
  local modname = preprocess(name)
  for _, plug in ipairs(plugins) do
    if name == plug then
      return true
    end
  end
end)

bench('single target compare lower', function(path)
  local name = path:match('^.+/(.+)/init%.lua$')
  if not name then
    return
  end
  local modname = preprocess(name)
  if modname == 'plugin_25000x' then
    return true
  end
end)

bench('single target compare direct', function(path)
  local name = path:match('^.+/(.+)/init%.lua$')
  if not name then
    return
  end
  local modname = preprocess(name)
  if name == 'plugin_25000x' then
    return true
  end
end)
