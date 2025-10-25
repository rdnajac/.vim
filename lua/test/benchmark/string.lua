--- Benchmark comparing path extraction strategies
--- Refactored to use the standardized benchmark framework

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
