--- Benchmark comparing vim.iter vs plain for loop vs vim.tbl_*
--- Refactored to use the standardized benchmark framework

local benchmark = require('test.util.benchmark')

-- Test data
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

-- Define benchmarks
local benchmarks = {
  { name = 'iter', fn = iter_ver },
  { name = 'for', fn = for_ver },
  { name = 'tbl', fn = tbl_ver },
}

-- Run benchmarks with standardized settings
local results = benchmark.run(benchmarks, {
  iterations = 999,
  warmup_iterations = 10,
  show_stats = true,
  sort_by = 'mean',
})

benchmark.print_results(results)
