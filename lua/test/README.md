# Benchmarking Utilities

This directory contains utilities and benchmarks for performance testing Lua code.

## Overview

The benchmarking framework provides:

1. **Word Utility (`util/words.lua`)**: Fetches random English words from the system dictionary for realistic test data
2. **Benchmark Framework (`util/benchmark.lua`)**: Standardized profiler-based benchmarking with statistical analysis

## Quick Start

### Using Random Words

```lua
local words = require('test.util.words')

-- Initialize (loads dictionary into memory)
words.init()

-- Get a single random word
local word = words.random_word()

-- Get multiple random words
local many_words = words.random_words(100)

-- Get unique random words (no duplicates)
local unique_words = words.random_words(50, true)

-- Get word count
print('Dictionary contains', words.count(), 'words')
```

### Running Benchmarks

```lua
local benchmark = require('test.util.benchmark')

-- Quick benchmark (simple timing)
benchmark.quick('my test', function()
  -- code to benchmark
end)

-- Multiple benchmarks with full statistics
local benchmarks = {
  {
    name = 'string.upper',
    fn = function()
      for i = 1, 1000 do
        local _ = string.upper('hello')
      end
    end,
  },
  {
    name = 'string.lower',
    fn = function()
      for i = 1, 1000 do
        local _ = string.lower('HELLO')
      end
    end,
  },
}

local results = benchmark.run(benchmarks, {
  iterations = 1000,       -- Number of times to run each benchmark
  warmup_iterations = 10,  -- Warmup runs before actual benchmark
  show_stats = true,       -- Show detailed statistics
  sort_by = 'mean',        -- Sort by: 'name', 'mean', 'min', 'max', 'total'
})

benchmark.print_results(results)
```

### Output Formats

The benchmark framework supports multiple output formats:

```lua
-- Table format (default) - human-readable
benchmark.print_results(results, { format = 'table' })

-- CSV format - for spreadsheets
benchmark.print_results(results, { format = 'csv' })

-- JSON format - for programmatic processing
benchmark.print_results(results, { format = 'json' })
```

## Example Output

### Table Format
```
Benchmark                  Mean         Min         Max      Median      StdDev
-------------------------------------------------------------------------------
string.upper              0.10        0.09        0.12        0.10        0.01
string.lower              0.11        0.10        0.13        0.11        0.01
```

### CSV Format
```
name,count,total,mean,min,max,median,stddev
string.upper,1000,103.45,0.1034,0.0920,0.1200,0.1000,0.0050
string.lower,1000,108.32,0.1083,0.1000,0.1300,0.1100,0.0060
```

## Statistics Explained

- **Mean**: Average execution time
- **Min**: Fastest execution time
- **Max**: Slowest execution time
- **Median**: Middle value when sorted by time
- **StdDev**: Standard deviation (consistency measure)

## Best Practices

1. **Use warmup iterations**: The first few runs are often slower due to caching
2. **Randomize benchmark order**: Reduces bias from system state changes
3. **Run enough iterations**: More iterations = more reliable statistics
4. **Use realistic data**: The words module provides real dictionary words instead of synthetic data
5. **Compare relative performance**: Focus on relative differences, not absolute times

## Migrating Existing Benchmarks

Old style:
```lua
local function bench(label, fn)
  local start = vim.loop.hrtime()
  for i = 1, 1000 do
    fn()
  end
  local elapsed = (vim.loop.hrtime() - start) / 1e6
  print(label, string.format('%.2f ms', elapsed))
end

bench('test', my_function)
```

New style:
```lua
local benchmark = require('test.util.benchmark')

benchmark.quick('test', function()
  for i = 1, 1000 do
    my_function()
  end
end, 1000)
```

Or for multiple benchmarks:
```lua
local benchmarks = {
  { name = 'test', fn = my_function },
}
local results = benchmark.run(benchmarks)
benchmark.print_results(results)
```

## Running Benchmarks

### In Neovim

```vim
:luafile lua/test/benchmark/name.lua
```

### Standalone Lua

Some benchmarks work with standalone Lua (requires `lua5.4` and `lua-socket`):

```bash
lua lua/test/benchmark_example.lua
```

## Files

- `util/words.lua` - Random word utility
- `util/benchmark.lua` - Benchmark framework
- `benchmark/*.lua` - Various performance benchmarks
- `test_words.lua` - Test script for words module
- `test_benchmark.lua` - Test script for benchmark framework
- `benchmark_example.lua` - Example using both utilities

## Requirements

For standalone execution (outside Neovim):
- Lua 5.4+
- lua-socket (for timing)
- System dictionary at `/usr/share/dict/words` or similar

For Neovim execution:
- Neovim with Lua support
