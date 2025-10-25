--- Benchmark comparing string lookup strategies
--- Refactored to use the standardized benchmark framework

local benchmark = require('test.util.benchmark')

-- Setup test data
local paths = {}
for i = 1, 5e4 do
  paths[i] = '/some/very/long/path/to/plugin_' .. i .. '_abcdefghi/init.lua'
end

-- Build 50 random plugin names of varying lengths
local plugins = {}
for i = 1, 50 do
  local name = 'plugin_' .. i .. string.rep('x', (i % 10) + 1)
  plugins[i] = name
end

-- Common preprocessing function
local function preprocess(name)
  return name:gsub('%.nvim$', ''):lower()
end

-- Define benchmarks
local benchmarks = {
  {
    name = 'list lookup lower (50 items)',
    fn = function()
      for i = 1, #paths do
        local path = paths[i]
        local name = path:match('^.+/(.+)/init%.lua$')
        if name then
          local modname = preprocess(name)
          for _, plug in ipairs(plugins) do
            if modname == plug then
              break
            end
          end
        end
      end
    end,
  },
  {
    name = 'list lookup direct (50 items)',
    fn = function()
      for i = 1, #paths do
        local path = paths[i]
        local name = path:match('^.+/(.+)/init%.lua$')
        if name then
          local modname = preprocess(name)
          for _, plug in ipairs(plugins) do
            if name == plug then
              break
            end
          end
        end
      end
    end,
  },
  {
    name = 'single target compare lower',
    fn = function()
      for i = 1, #paths do
        local path = paths[i]
        local name = path:match('^.+/(.+)/init%.lua$')
        if name then
          local modname = preprocess(name)
          if modname == 'plugin_25000x' then
            break
          end
        end
      end
    end,
  },
  {
    name = 'single target compare direct',
    fn = function()
      for i = 1, #paths do
        local path = paths[i]
        local name = path:match('^.+/(.+)/init%.lua$')
        if name then
          local modname = preprocess(name)
          if name == 'plugin_25000x' then
            break
          end
        end
      end
    end,
  },
}

-- Run benchmarks with standardized settings
local results = benchmark.run(benchmarks, {
  iterations = 10,
  warmup_iterations = 2,
  show_stats = true,
  sort_by = 'mean',
})

-- Print results
benchmark.print_results(results)
