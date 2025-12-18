local benchmark = require('test.benchmark')

local config_dir = vim.fn.stdpath('config') .. '/after/lsp'
local files = vim.fn.globpath(config_dir, '*.lua', true, true)

benchmark.run({
  ['vim.fs.basename + sub'] = function()
    return vim.tbl_map(function(path)
      local name = vim.fs.basename(path)
      return name:match('(.+)%.lua$') or name
    end, files)
  end,
  ['fnamemodify :t:r'] = function()
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
})
