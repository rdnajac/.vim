-- what's the best way to get a list of files
local benchmark = require('test.benchmark')
local files = vim.api.nvim_get_runtime_file('lua/nvim/*/init.lua', true)

local wrap = function(mod_fn)
  return function(mod_fn)
    return vim.tbl_map(mod_fn, files)
  end
end

local M = {
  ['vim.fs'] = wrap(function(f)
    return vim.fs.relpath(vim.fn.stdpath('config') .. '/lua', vim.fs.dirname(f))
  end),
  ['fnamemodify'] = wrap(function(f)
    return vim.fn.fnamemodify(f, ':t')
  end),
  ['string.match'] = wrap(function(f)
    return f:match('([^./]+)$')
  end),
}

benchmark.run(M, {}, false)
