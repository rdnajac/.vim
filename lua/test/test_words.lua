--- Test script for the benchmark utilities
--- This script demonstrates the functionality of the words and benchmark modules

-- Add the test directory to the package path
package.path = package.path .. ';/home/runner/work/.vim/.vim/lua/?.lua'

local words = require('test.util.words')

print('=== Testing Words Module ===')
print()

-- Test initialization
local init_success = words.init()
print('Dictionary initialized:', init_success)
print('Dictionary path:', words.dict_path())
print('Word count:', words.count())
print()

-- Test random word
print('Random word:', words.random_word())
print()

-- Test multiple random words
print('5 random words:')
local five_words = words.random_words(5)
for i, word in ipairs(five_words) do
  print(string.format('  %d. %s', i, word))
end
print()

-- Test unique random words
print('5 unique random words:')
local unique_words = words.random_words(5, true)
for i, word in ipairs(unique_words) do
  print(string.format('  %d. %s', i, word))
end
print()

print('=== Words Module Test Complete ===')
