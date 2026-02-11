local benchmark = require('test.benchmark')

local cases = {
  'user/repo.nvim',
  'user/other-plugin',
  '/some/long/path/to/file.nvim',
  'plainstring',
}

benchmark.run({
  endswith = function()
    local res = {}
    for _, s in ipairs(cases) do
      local last = s:match('([^/]+)$') or s
      if vim.endswith(last, '.nvim') then
        res[#res + 1] = last:sub(1, -6)
      else
        res[#res + 1] = last
      end
    end
    return res
  end,
  ['split+sub'] = function()
    local res = {}
    for _, s in ipairs(cases) do
      local part = s:match('([^/]+)$') or s
      res[#res + 1] = part:sub(-5) == '.nvim' and part:sub(1, -6) or part
    end
    return res
  end,
  ['find+sub'] = function()
    local res = {}
    for _, s in ipairs(cases) do
      local idx = s:match('.*()/')
      local part = idx and s:sub(idx + 1) or s
      res[#res + 1] = part:sub(-5) == '.nvim' and part:sub(1, -6) or part
    end
    return res
  end,
  ['pattern+gsub'] = function()
    local res = {}
    for _, s in ipairs(cases) do
      res[#res + 1] = s:match('([^/]+)$'):gsub('%.nvim$', '')
    end
    return res
  end,
  gsub_first = function()
    local res = {}
    for _, s in ipairs(cases) do
      local stripped = s:gsub('%.nvim$', '')
      res[#res + 1] = stripped:match('([^/]+)$')
    end
    return res
  end,
  gsub_only = function()
    local res = {}
    for _, s in ipairs(cases) do
      local last = s:gsub('.*/', '')
      res[#res + 1] = last:gsub('%.nvim$', '')
    end
    return res
  end,
  find_suffix = function()
    local res = {}
    for _, s in ipairs(cases) do
      local last = s:match('([^/]+)$') or s
      local suffix = '.nvim'
      local len = #last - #suffix + 1
      if last:sub(len) == suffix then
        res[#res + 1] = last:sub(1, len - 1)
      else
        res[#res + 1] = last
      end
    end
    return res
  end,
  oneliner = function()
    local res = {}
    for _, s in ipairs(cases) do
      res[#res + 1] = (s:sub((s:match('.*()/') or 0) + 1):gsub('%.nvim$', ''))
    end
    return res
  end,
}, { counts = 1e5 })
