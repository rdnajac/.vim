--- This is the main entry point for plugin configurations using the new,
--- native `vim.pack` plugin manager in neovim. This module return a list of
--- of plugin specifications to be used by `vim.pack` in a format similar to
--- `lazy.nvim`'s LazySpec

local M = {
  require('nvim.colorscheme'),
  require('nvim.snacks'),
}

local path = vim.fs.dirname(debug.getinfo(1).source:sub(2))
local files = vim.fn.globpath(path, '*.lua', false, true)
local iter = vim.iter(files)


-- TODO: finish bench
local fn2 = function()
  return vim
    .iter(files)
    :filter(function(f)
      return not vim.endswith(f, 'init.lua')
    end)
    :map(function(f)
      local m = dofile(f)
      return vim.islist(m) and m or { m }
    end)
    :flatten()
    :totable()
end

local fn1 = function()
  return vim
    .iter(files)
    :filter(function(f)
      return not vim.endswith(f, 'init.lua')
    end)
    :map(dofile)
    :map(function(mod)
      return vim.islist(mod) and mod or { mod }
    end)
    :flatten()
    :totable()
end


local Bench = require('nvim.munchies.bench')
-- Bench(fn1, { title = 'fn1' })
-- Bench(fn2)

return vim.list_extend(M, fn1())
