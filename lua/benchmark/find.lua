math.randomseed(os.time())

local function run_benches(t)
  local benches = {}

  if vim.islist(t) then
    benches = t
  else
    -- assume dictionary of label → fn
    for label, fn in pairs(t) do
      table.insert(benches, { label = label, fn = fn })
    end
  end

  -- shuffle
  for i = #benches, 2, -1 do
    local j = math.random(i)
    benches[i], benches[j] = benches[j], benches[i]
  end

  local results = {}
  for _, b in ipairs(benches) do
    local start = vim.loop.hrtime()
    for _ = 1, 1000 do
      b.fn()
    end
    local elapsed = (vim.loop.hrtime() - start) / 1e6
    table.insert(results, { label = b.label, time = elapsed })
  end

  table.sort(results, function(a, b)
    return a.label < b.label
  end)

  for _, r in ipairs(results) do
    print(r.label, string.format('%.2f ms', r.time))
  end
end

local pattern = 'after/lsp/*.lua'
local config_cache = vim.fn.stdpath('config')
local path = config_cache .. '/after/lsp'

local M = {}

M.globpath = function()
  return vim.fn.globpath(vim.o.runtimepath, pattern, true, true)
end

M.globpath_config = function()
  return vim.fn.globpath(config_cache, pattern, true, true)
end

M.globpath_config_precise = function()
  return vim.fn.globpath(path, pattern, true, true)
end

M.nvim_get_runtime_file = function()
  return vim.api.nvim_get_runtime_file(pattern, true)
end

M.scandir = function()
  local fd = vim.loop.fs_scandir(config_cache)
  local items = {}
  if fd then
    while true do
      local name = vim.loop.fs_scandir_next(fd)
      if not name then
        break
      end
      table.insert(items, name)
    end
  end
  return items
end

M.dir = function()
  return vim
    .iter(vim.fs.dir(config_cache))
    :map(function(name)
      return name
    end)
    :totable()
end

M.dir_precise = function()
  return vim
    .iter(vim.fs.dir(config_cache))
    :map(function(name)
      return name
    end)
    :totable()
end

-- build benches list from M
local benches = {}
for label, fn in pairs(M) do
  table.insert(benches, { label = label, fn = fn })
end

run_benches(M)

return M
