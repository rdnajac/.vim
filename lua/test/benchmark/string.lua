--- Benchmark comparing path extraction strategies
--- Refactored to use the standardized benchmark framework

-- Add the test directory to the package path for standalone execution
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

-- Setup test data
local paths = {}
for i = 1, 1e5 do
  paths[i] = '/some/very/long/path/to/file' .. i .. '.lua'
end

-- Define benchmarks
local benchmarks = {
  {
    name = 'match %.lua$',
    fn = function()
      for i = 1, #paths do
        local _ = paths[i]:match('^.+/(.+)%.lua$')
      end
    end,
  },
  {
    name = 'match + sub',
    fn = function()
      for i = 1, #paths do
        local _ = paths[i]:match('^.+/(.+)'):sub(1, -5)
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
