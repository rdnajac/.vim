--- Test script for the benchmark framework
--- This script demonstrates the functionality of the benchmark module

-- Setup for standalone execution
local function init_standalone()
  local cwd = io.popen('pwd'):read('*l')
  local lua_dir
  if cwd:find('/lua') then
    lua_dir = cwd:match('(.*)/lua') .. '/lua/'
  else
    lua_dir = cwd .. '/lua/'
  end
  package.path = package.path .. ';' .. lua_dir .. '?.lua'
  if not vim then
    require('test.util.standalone').init()
  end
end
init_standalone()

local benchmark = require('test.util.benchmark')

print('=== Testing Benchmark Framework ===')
print()

-- Test quick benchmark
print('1. Quick benchmark test:')
benchmark.quick('string concat', function()
  local s = ''
  for i = 1, 100 do
    s = s .. 'x'
  end
end)
print()

-- Test multiple benchmarks with different string operations
print('2. Running multiple benchmarks:')
local benchmarks = {
  {
    name = 'string.format',
    fn = function()
      for i = 1, 100 do
        local _ = string.format('%d', i)
      end
    end,
  },
  {
    name = 'tostring',
    fn = function()
      for i = 1, 100 do
        local _ = tostring(i)
      end
    end,
  },
  {
    name = 'concatenation',
    fn = function()
      for i = 1, 100 do
        local _ = '' .. i
      end
    end,
  },
}

local results = benchmark.run(benchmarks, {
  iterations = 500,
  warmup_iterations = 5,
  show_stats = true,
})

benchmark.print_results(results)
print()

-- Test with different output formats
print('3. CSV format:')
benchmark.print_results(results, { format = 'csv' })
print()

print('=== Benchmark Framework Test Complete ===')
