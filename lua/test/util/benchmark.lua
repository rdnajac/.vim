--- Standardized benchmarking framework with profiler support
--- Provides consistent timing, statistics, and result formatting

local M = {}

-- Configuration
M.config = {
  iterations = 1000, -- Default number of iterations
  warmup_iterations = 10, -- Warmup runs before actual benchmark
  format = 'table', -- Output format: 'table', 'csv', 'json'
  sort_by = 'mean', -- Sort results by: 'name', 'mean', 'min', 'max', 'total'
  show_stats = true, -- Show statistical information
}

--- Simple profiler for tracking execution time
local Profiler = {}
Profiler.__index = Profiler

function Profiler.new()
  local self = setmetatable({}, Profiler)
  self.results = {}
  return self
end

function Profiler:start(name)
  if not self.results[name] then
    self.results[name] = {
      times = {},
      total = 0,
      count = 0,
    }
  end
  self.results[name].start_time = vim.loop.hrtime()
end

function Profiler:stop(name)
  local elapsed = (vim.loop.hrtime() - self.results[name].start_time) / 1e6 -- Convert to ms
  table.insert(self.results[name].times, elapsed)
  self.results[name].total = self.results[name].total + elapsed
  self.results[name].count = self.results[name].count + 1
  self.results[name].start_time = nil
end

function Profiler:get_stats(name)
  local result = self.results[name]
  if not result or result.count == 0 then
    return nil
  end

  local times = result.times
  table.sort(times)

  local mean = result.total / result.count
  local min = times[1]
  local max = times[#times]
  local median = times[math.ceil(#times / 2)]

  -- Calculate standard deviation
  local sum_sq_diff = 0
  for _, time in ipairs(times) do
    sum_sq_diff = sum_sq_diff + (time - mean) ^ 2
  end
  local stddev = math.sqrt(sum_sq_diff / result.count)

  return {
    name = name,
    count = result.count,
    total = result.total,
    mean = mean,
    min = min,
    max = max,
    median = median,
    stddev = stddev,
  }
end

function Profiler:get_all_stats()
  local stats = {}
  for name, _ in pairs(self.results) do
    local stat = self:get_stats(name)
    if stat then
      table.insert(stats, stat)
    end
  end
  return stats
end

--- Run a benchmark function multiple times and collect statistics
---@param name string Name of the benchmark
---@param fn function Function to benchmark
---@param opts? table Options: iterations, warmup_iterations
---@return table stats Statistics for this benchmark
function M.bench(name, fn, opts)
  opts = vim.tbl_extend('force', M.config, opts or {})

  -- Warmup
  for _ = 1, opts.warmup_iterations do
    fn()
  end

  -- Actual benchmark
  local profiler = Profiler.new()
  for _ = 1, opts.iterations do
    profiler:start(name)
    fn()
    profiler:stop(name)
  end

  return profiler:get_stats(name)
end

--- Run multiple benchmarks and return results
---@param benchmarks table List of benchmarks: {{name = "test", fn = function}}
---@param opts? table Options for all benchmarks
---@return table results List of statistics for all benchmarks
function M.run(benchmarks, opts)
  opts = vim.tbl_extend('force', M.config, opts or {})

  -- Randomize order to reduce bias
  math.randomseed(os.time())
  local shuffled = vim.deepcopy(benchmarks)
  for i = #shuffled, 2, -1 do
    local j = math.random(i)
    shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
  end

  -- Run benchmarks
  local results = {}
  for _, bench_spec in ipairs(shuffled) do
    local stats = M.bench(bench_spec.name or bench_spec.label or 'unnamed', bench_spec.fn, opts)
    table.insert(results, stats)
  end

  -- Sort results
  M.sort_results(results, opts.sort_by)

  return results
end

--- Sort benchmark results
---@param results table List of statistics
---@param sort_by string Field to sort by: 'name', 'mean', 'min', 'max', 'total'
function M.sort_results(results, sort_by)
  local comparators = {
    name = function(a, b)
      return a.name < b.name
    end,
    mean = function(a, b)
      return a.mean < b.mean
    end,
    min = function(a, b)
      return a.min < b.min
    end,
    max = function(a, b)
      return a.max < b.max
    end,
    total = function(a, b)
      return a.total < b.total
    end,
  }

  local comparator = comparators[sort_by] or comparators.mean
  table.sort(results, comparator)
end

--- Format and print benchmark results
---@param results table List of statistics
---@param opts? table Formatting options
function M.print_results(results, opts)
  opts = vim.tbl_extend('force', M.config, opts or {})

  if opts.format == 'csv' then
    M.print_csv(results)
  elseif opts.format == 'json' then
    M.print_json(results)
  else
    M.print_table(results, opts.show_stats)
  end
end

--- Print results in table format
---@param results table List of statistics
---@param show_stats boolean Whether to show detailed statistics
function M.print_table(results, show_stats)
  -- Calculate column widths
  local max_name_len = 10
  for _, stat in ipairs(results) do
    max_name_len = math.max(max_name_len, #stat.name)
  end

  -- Print header
  if show_stats then
    local header = string.format(
      '%-' .. max_name_len .. 's  %10s  %10s  %10s  %10s  %10s',
      'Benchmark',
      'Mean',
      'Min',
      'Max',
      'Median',
      'StdDev'
    )
    print(header)
    print(string.rep('-', #header))
  else
    local header = string.format('%-' .. max_name_len .. 's  %10s', 'Benchmark', 'Mean')
    print(header)
    print(string.rep('-', #header))
  end

  -- Print results
  for _, stat in ipairs(results) do
    if show_stats then
      print(
        string.format(
          '%-' .. max_name_len .. 's  %10.2f  %10.2f  %10.2f  %10.2f  %10.2f',
          stat.name,
          stat.mean,
          stat.min,
          stat.max,
          stat.median,
          stat.stddev
        )
      )
    else
      print(string.format('%-' .. max_name_len .. 's  %10.2f ms', stat.name, stat.mean))
    end
  end
end

--- Print results in CSV format
---@param results table List of statistics
function M.print_csv(results)
  print('name,count,total,mean,min,max,median,stddev')
  for _, stat in ipairs(results) do
    print(
      string.format(
        '%s,%d,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f',
        stat.name,
        stat.count,
        stat.total,
        stat.mean,
        stat.min,
        stat.max,
        stat.median,
        stat.stddev
      )
    )
  end
end

--- Print results in JSON format
---@param results table List of statistics
function M.print_json(results)
  print(vim.json.encode(results))
end

--- Quick benchmark function for simple cases
---@param name string Name of the benchmark
---@param fn function Function to benchmark
---@param iterations? number Number of iterations (default: 1000)
function M.quick(name, fn, iterations)
  local stats = M.bench(name, fn, { iterations = iterations or 1000 })
  print(string.format('%s: %.2f ms (mean)', stats.name, stats.mean))
end

return M
