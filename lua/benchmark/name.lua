local cases = {
  'user/repo.nvim',
  'user/other-plugin',
  '/some/long/path/to/file.nvim',
  'plainstring',
}

-- original (pattern + gsub)
local function name_pattern_gsub(s)
  return s:match('([^/]+)$'):gsub('%.nvim$', '')
end

-- split by "/" then strip suffix
local function name_split(s)
  local part = s:match('([^/]+)$') or s
  return part:sub(-5) == '.nvim' and part:sub(1, -6) or part
end

-- find last "/" index manually
local function name_find(s)
  local idx = s:match('.*()/')
  local part = idx and s:sub(idx + 1) or s
  return part:sub(-5) == '.nvim' and part:sub(1, -6) or part
end

-- use gsub to directly remove `.nvim` suffix first, then get last part
local function name_gsub_first(s)
  local stripped = s:gsub('%.nvim$', '')
  return stripped:match('([^/]+)$')
end

-- pure gsub trick: replace path separators with "" then remove suffix
local function name_gsub_only(s)
  local last = s:gsub('.*/', '')
  return last:gsub('%.nvim$', '')
end

-- string.find suffix + slicing
local function name_find_suffix(s)
  local last = s:match('([^/]+)$') or s
  local suffix = '.nvim'
  local len = #last - #suffix + 1
  if last:sub(len) == suffix then
    return last:sub(1, len - 1)
  end
  return last
end

-- vim.endswith
local function name_find_suffix(s)
  local last = s:match('([^/]+)$') or s
  local suffix = '.nvim'
  local len = #last - #suffix + 1
  if last:sub(len) == suffix then
    return last:sub(1, len - 1)
  end
  return last
end

local function name_endswith(s)
  local last = s:match('([^/]+)$') or s
  if vim.endswith(last, '.nvim') then
    return last:sub(1, -6)
  end
  return last
end

local function name_find_oneliner(s)
  return (s:sub((s:match('.*()/') or 0) + 1):gsub('%.nvim$', ''))
end

local function bench(label, fn)
  local start = vim.loop.hrtime()
  for i = 1, 1e5 do
    fn(cases[(i % #cases) + 1])
  end
  local elapsed = (vim.loop.hrtime() - start) / 1e6
  print(label, string.format('%.2f ms', elapsed))
end

bench('endswith', name_endswith)
bench('split+sub', name_split)
bench('find+sub', name_find)
bench('pattern+gsub', name_pattern_gsub)
bench('gsub_first', name_gsub_first)
bench('gsub_only', name_gsub_only)
bench('find_suffix', name_find_suffix)
bench('oneliner', name_find_oneliner)
