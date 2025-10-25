--- Utility module for fetching random English words from the system dictionary
--- Used for benchmarking purposes to provide realistic string data

local M = {}

-- Default dictionary paths to try (in order)
local DICT_PATHS = {
  '/usr/share/dict/words',
  '/usr/share/dict/american-english',
  '/usr/share/dict/british-english',
  '/usr/dict/words',
}

-- Cache for loaded words
local word_cache = nil
local dict_path = nil

--- Find available dictionary file
---@return string|nil path Path to dictionary file, or nil if not found
local function find_dict()
  for _, path in ipairs(DICT_PATHS) do
    local fd = io.open(path, 'r')
    if fd then
      fd:close()
      return path
    end
  end
  return nil
end

--- Load all words from dictionary file into memory
---@param path string Path to dictionary file
---@return table words Table of words
local function load_words(path)
  local words = {}
  local fd = io.open(path, 'r')
  if not fd then
    error('Cannot open dictionary file: ' .. path)
  end

  for line in fd:lines() do
    local word = line:match('^%s*(.-)%s*$') -- trim whitespace
    if word and #word > 0 then
      table.insert(words, word)
    end
  end
  fd:close()

  return words
end

--- Initialize the word cache
---@return boolean success True if initialized successfully
function M.init()
  if word_cache then
    return true
  end

  dict_path = find_dict()
  if not dict_path then
    return false
  end

  word_cache = load_words(dict_path)
  return #word_cache > 0
end

--- Get a random word from the dictionary
---@return string word A random word
function M.random_word()
  if not word_cache then
    M.init()
  end

  if not word_cache or #word_cache == 0 then
    error('No words available. Dictionary not loaded.')
  end

  local idx = math.random(1, #word_cache)
  return word_cache[idx]
end

--- Get multiple random words
---@param count number Number of words to fetch
---@param unique? boolean If true, ensure all words are unique (default: false)
---@return table words Table of random words
function M.random_words(count, unique)
  if not word_cache then
    M.init()
  end

  if not word_cache or #word_cache == 0 then
    error('No words available. Dictionary not loaded.')
  end

  local words = {}
  if unique then
    -- Ensure we don't request more unique words than available
    local max_count = math.min(count, #word_cache)
    local used = {}
    for _ = 1, max_count do
      local word
      repeat
        word = M.random_word()
      until not used[word]
      used[word] = true
      table.insert(words, word)
    end
  else
    for _ = 1, count do
      table.insert(words, M.random_word())
    end
  end

  return words
end

--- Get all words from the dictionary
---@return table words All words in the dictionary
function M.all_words()
  if not word_cache then
    M.init()
  end
  return word_cache or {}
end

--- Get the path to the dictionary file being used
---@return string|nil path Path to dictionary file, or nil if not initialized
function M.dict_path()
  return dict_path
end

--- Get the number of words in the dictionary
---@return number count Number of words
function M.count()
  if not word_cache then
    M.init()
  end
  return word_cache and #word_cache or 0
end

return M
