local function bench(label, fn)
  local start = vim.loop.hrtime()
  for i = 1, 999 do
    fn()
  end
  local elapsed = (vim.loop.hrtime() - start) / 1e6
  print(label, string.format('%.2f ms total | %.4f ms avg', elapsed, elapsed / 999))
end

-- test data
local plugs = vim.pack.get()

-- 1. vim.iter chain
local function iter_ver()
  return vim
    .iter(plugs)
    :filter(function(p)
      return not p.active
    end)
    :map(function(p)
      return p.spec.name
    end)
    :totable()
end

-- 2. plain for loop
local function for_ver()
  local names = {}
  for _, p in ipairs(plugs) do
    if not p.active then
      names[#names + 1] = p.spec.name
    end
  end
  return names
end

-- 3. vim.tbl_map + vim.tbl_filter
local function tbl_ver()
  local filtered = vim.tbl_filter(function(p)
    return not p.active
  end, plugs)
  return vim.tbl_map(function(p)
    return p.spec.name
  end, filtered)
end

bench('iter', iter_ver)
bench('for', for_ver)
bench('tbl', tbl_ver)
