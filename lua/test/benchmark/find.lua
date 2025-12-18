local benchmark = require('test.benchmark')

local pattern = 'after/lsp/*.lua'
local config_cache = vim.fn.stdpath('config')
local path = config_cache .. '/after/lsp'

benchmark.run({
  globpath = function()
    return vim.fn.globpath(vim.o.runtimepath, pattern, true, true)
  end,
  globpath_config = function()
    return vim.fn.globpath(config_cache, pattern, true, true)
  end,
  globpath_config_precise = function()
    return vim.fn.globpath(path, pattern, true, true)
  end,
  nvim_get_runtime_file = function()
    return vim.api.nvim_get_runtime_file(pattern, true)
  end,
  scandir = function()
    local fd = vim.loop.fs_scandir(config_cache)
    local items = {}
    if fd then
      while true do
        local name = vim.loop.fs_scandir_next(fd)
        if not name then
          break
        end
        table.insert(items, name)
      end
    end
    return items
  end,
  dir = function()
    return vim
      .iter(vim.fs.dir(config_cache))
      :map(function(name)
        return name
      end)
      :totable()
  end,
  dir_precise = function()
    return vim
      .iter(vim.fs.dir(config_cache))
      :map(function(name)
        return name
      end)
      :totable()
  end,
  readdir = function()
    return vim.fn.readdir(config_cache)
  end,
})
