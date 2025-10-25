--- Benchmark comparing GitHub URL matching strategies
--- Refactored to use the standardized benchmark framework

local benchmark = require('test.util.benchmark')

-- Setup test data
local paths = {}
for i = 1, 1e5 do
  paths[i] = 'user/repo' .. i -- valid GitHub-style
end

local gh = function(s)
  return s:match('^[%w._-]+/[%w._-]+$') and 'https://github.com/' .. s .. '.git' or s
end

local gh_unsafe = function(s)
  return 'https://github.com/' .. s .. '.git'
end

-- Define benchmarks
local benchmarks = {
  {
    name = 'gh safe',
    fn = function()
      for i = 1, #paths do
        gh(paths[i])
      end
    end,
  },
  {
    name = 'gh unsafe',
    fn = function()
      for i = 1, #paths do
        gh_unsafe(paths[i])
      end
    end,
  },
}

-- Run benchmarks with standardized settings
local results = benchmark.run(benchmarks, {
  iterations = 10,
  warmup_iterations = 2,
  show_stats = false,
  sort_by = 'mean',
})

benchmark.print_results(results)
