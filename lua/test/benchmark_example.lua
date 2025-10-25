--- Example benchmark using random words from the dictionary
--- Demonstrates benchmarking string operations with realistic data

-- Add the test directory to the package path
package.path = package.path .. ';/home/runner/work/.vim/.vim/lua/?.lua'

-- Mock vim.loop for standalone lua
if not vim then
  vim = {}
  local socket = require('socket')
  vim.loop = {
    hrtime = function()
      return socket.gettime() * 1e9
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
  vim.json = { encode = function(tbl)
    return '{}'
  end }
end

local benchmark = require('test.util.benchmark')
local words = require('test.util.words')

-- Initialize words
words.init()

-- Get test data
local test_words = words.random_words(1000)

print('=== String Operation Benchmarks with Random Words ===')
print('Using ' .. #test_words .. ' random words from system dictionary')
print()

-- Define benchmarks
local benchmarks = {
  {
    name = 'uppercase',
    fn = function()
      for _, word in ipairs(test_words) do
        local _ = string.upper(word)
      end
    end,
  },
  {
    name = 'lowercase',
    fn = function()
      for _, word in ipairs(test_words) do
        local _ = string.lower(word)
      end
    end,
  },
  {
    name = 'reverse',
    fn = function()
      for _, word in ipairs(test_words) do
        local _ = string.reverse(word)
      end
    end,
  },
  {
    name = 'gsub single',
    fn = function()
      for _, word in ipairs(test_words) do
        local _ = word:gsub('a', 'A')
      end
    end,
  },
  {
    name = 'match pattern',
    fn = function()
      for _, word in ipairs(test_words) do
        local _ = word:match('^%w+$')
      end
    end,
  },
  {
    name = 'sub (first 5 chars)',
    fn = function()
      for _, word in ipairs(test_words) do
        local _ = word:sub(1, 5)
      end
    end,
  },
}

-- Run benchmarks
local results = benchmark.run(benchmarks, {
  iterations = 100,
  warmup_iterations = 5,
  show_stats = true,
  sort_by = 'mean',
})

-- Print results
benchmark.print_results(results)

print()
print('=== Benchmark Complete ===')
