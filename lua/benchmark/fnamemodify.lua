local config_dir = vim.fn.stdpath('config') .. '/after/lsp'
local files = vim.fn.globpath(config_dir, '*', true, true)

local function bench(label, fn)
  local start = vim.loop.hrtime()
  for _ = 1, 1000 do
    fn(files)
  end
  local elapsed = (vim.loop.hrtime() - start) / 1e6
  print(label, string.format('%.2f ms', elapsed))
end

-- version A: vim.fs.basename + sub
local function servers_fs(files)
  return vim.tbl_map(function(path)
    return vim.fs.basename(path):sub(1, -5)
  end, files)
end

-- version B: fnamemodify(:t:r)
local function servers_fn(files)
  return vim.tbl_map(function(path)
    return vim.fn.fnamemodify(path, ':t:r')
  end, files)
end

-- version C: regex match
local function match(files)
  return vim.tbl_map(function(path)
    return path:match('^.+/(.+)%.lua$')
  end, files)
end

local function match_sub(files)
  return vim.tbl_map(function(path)
    return path:match('^.+/(.+)$'):sub(1, -5)
  end, files)
end

bench('vim.fs.basename + sub', servers_fs)
bench('fnamemodify :t:r', servers_fn)
bench('regex match', match)
bench('regex match with sub', match_sub)
