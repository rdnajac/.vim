--- Test script for the words module
--- This script demonstrates the functionality of the words module

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
end
init_standalone()

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
