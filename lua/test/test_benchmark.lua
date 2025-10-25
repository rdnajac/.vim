--- Test script for the benchmark framework
--- This script demonstrates the functionality of the benchmark module

-- Add the test directory to the package path
package.path = package.path .. ';/home/runner/work/.vim/.vim/lua/?.lua'

-- Mock vim.loop for standalone lua
if not vim then
  vim = {}
  local socket = require('socket')
  vim.loop = {
    hrtime = function()
      return socket.gettime() * 1e9 -- Convert to nanoseconds
    end,
  }
  vim.tbl_extend = function(behavior, ...)
    local result = {}
    for _, tbl in ipairs({ ... }) do
      for k, v in pairs(tbl) do
        result[k] = v
      end
    end
    return result
  end
  vim.deepcopy = function(tbl)
    if type(tbl) ~= 'table' then
      return tbl
    end
    local result = {}
    for k, v in pairs(tbl) do
      result[k] = vim.deepcopy(v)
    end
    return result
  end
  vim.json = {
    encode = function(tbl)
      -- Simple JSON encoding for testing
      local function encode_value(val)
        if type(val) == 'string' then
          return '"' .. val .. '"'
        elseif type(val) == 'number' then
          return tostring(val)
        elseif type(val) == 'table' then
          local items = {}
          for k, v in pairs(val) do
            table.insert(items, encode_value(k) .. ':' .. encode_value(v))
          end
          return '{' .. table.concat(items, ',') .. '}'
        else
          return tostring(val)
        end
      end
      return encode_value(tbl)
    end,
  }
end

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
