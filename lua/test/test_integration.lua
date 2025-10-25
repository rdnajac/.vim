--- Integration test for benchmarking utilities
--- Tests both words and benchmark modules together

-- Setup for standalone execution
local function init_standalone()
  -- Get current working directory
  local cwd = io.popen('pwd'):read('*l')
  
  -- Find lua directory
  local lua_dir
  if cwd:find('/lua') then
    lua_dir = cwd:match('(.*)/lua') .. '/lua/'
  else
    lua_dir = cwd .. '/lua/'
  end
  
  -- Add to package path
  package.path = package.path .. ';' .. lua_dir .. '?.lua'
  
  -- Mock vim if needed
  if not vim then
    require('test.util.standalone').init()
  end
end
init_standalone()

local words = require('test.util.words')
local benchmark = require('test.util.benchmark')

print('=== Integration Test: Words + Benchmark Utilities ===')
print()

-- Test 1: Words module initialization
print('Test 1: Words module initialization')
local init_ok = words.init()
assert(init_ok, 'Failed to initialize words module')
assert(words.count() > 0, 'Word count should be greater than 0')
print('✓ Words module initialized successfully')
print('  Dictionary:', words.dict_path())
print('  Word count:', words.count())
print()

-- Test 2: Random word generation
print('Test 2: Random word generation')
local word1 = words.random_word()
assert(type(word1) == 'string', 'random_word should return a string')
assert(#word1 > 0, 'random_word should return non-empty string')
print('✓ Random word generation works:', word1)
print()

-- Test 3: Multiple random words
print('Test 3: Multiple random words')
local many_words = words.random_words(10)
assert(#many_words == 10, 'Should return 10 words')
for i, word in ipairs(many_words) do
  assert(type(word) == 'string', 'Each word should be a string')
  assert(#word > 0, 'Each word should be non-empty')
end
print('✓ Multiple random words work')
print()

-- Test 4: Unique random words
print('Test 4: Unique random words')
local unique_words = words.random_words(10, true)
assert(#unique_words == 10, 'Should return 10 unique words')
local seen = {}
for _, word in ipairs(unique_words) do
  assert(not seen[word], 'Words should be unique')
  seen[word] = true
end
print('✓ Unique random words work')
print()

-- Test 5: Quick benchmark
print('Test 5: Quick benchmark')
benchmark.quick('test function', function()
  local _ = string.upper('hello')
end, 100)
print('✓ Quick benchmark works')
print()

-- Test 6: Multiple benchmarks with words
print('Test 6: Multiple benchmarks using random words')
local test_data = words.random_words(100)
local benchmarks = {
  {
    name = 'uppercase',
    fn = function()
      for _, word in ipairs(test_data) do
        local _ = string.upper(word)
      end
    end,
  },
  {
    name = 'lowercase',
    fn = function()
      for _, word in ipairs(test_data) do
        local _ = string.lower(word)
      end
    end,
  },
}

local results = benchmark.run(benchmarks, {
  iterations = 50,
  warmup_iterations = 5,
  show_stats = false,
})

assert(#results == 2, 'Should have 2 benchmark results')
for _, result in ipairs(results) do
  assert(result.name, 'Result should have a name')
  assert(result.mean, 'Result should have mean time')
  assert(result.count == 50, 'Result should have correct iteration count')
end
benchmark.print_results(results)
print('✓ Multiple benchmarks work')
print()

-- Test 7: Different output formats
print('Test 7: Output formats')
print('CSV format:')
benchmark.print_results(results, { format = 'csv', show_stats = false })
print('✓ CSV format works')
print()

-- Test 8: Statistics
print('Test 8: Statistics validation')
for _, result in ipairs(results) do
  assert(result.min <= result.mean, 'Min should be <= mean')
  assert(result.mean <= result.max, 'Mean should be <= max')
  assert(result.min <= result.median, 'Min should be <= median')
  assert(result.median <= result.max, 'Median should be <= max')
  assert(result.stddev >= 0, 'StdDev should be >= 0')
end
print('✓ Statistics are valid')
print()

print('=== All Integration Tests Passed! ===')
print()
print('Summary:')
print('- Words module: ✓ Working')
print('- Benchmark framework: ✓ Working')
print('- Integration: ✓ Working')
print('- Output formats: ✓ Working')
print('- Statistics: ✓ Valid')
