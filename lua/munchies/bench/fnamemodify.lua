local bench = require('test.benchmark').run

local files = vim.api.nvim_get_runtime_file('lua/nvim/*/init.lua', true)

local foo = function(f)
  return vim.fn.fnamemodify(f, ':h:t')
end

local x = vim.tbl_map(foo, files)

local M = {
  ['vim.fs.basename + sub'] = function()
    return vim.tbl_map(function(path)
      local name = vim.fs.basename(path)
      return name:match('(.+)%.lua$') or name
    end, files)
  end,
  ['fnamemodify :t'] = function()
    return vim.tbl_map(function(path)
      return vim.fn.fnamemodify(path, ':t:r')
    end, files)
  end,
  ['regex match'] = function()
    return vim.tbl_map(function(path)
      return path:match('^.+/(.+)%.lua$')
    end, files)
  end,
  ['regex match with sub'] = function()
    return vim.tbl_map(function(path)
      local name = path:match('^.+/(.+)$')
      return name:match('(.+)%.lua$') or name
    end, files)
  end,
}

-- bench(M)
