local benchmark = require('test.benchmark')

local dir = vim.fs.joinpath(vim.fn.stdpath('config'), 'lua', 'nvim') .. '/'

benchmark.run({
  ['globpath + iter + fnamemodify'] = function()
    local files = vim.fn.globpath(dir, '*', false, true)
    return vim
      .iter(files)
      :filter(function(f)
        if vim.fn.isdirectory(f) == 1 then
          return vim.uv.fs_stat(f .. '/init.lua') ~= nil
        else
          return not vim.endswith(f, 'init.lua')
        end
      end)
      :map(function(f) return vim.fn.fnamemodify(f, ':r:s?^.*/lua/??') end)
      :totable()
  end,
  ['globpath + iter inline'] = function()
    return vim
      .iter(vim.fn.globpath(dir, '*', false, true))
      :filter(function(f)
        if vim.fn.isdirectory(f) == 1 then
          return vim.uv.fs_stat(f .. '/init.lua') ~= nil
        else
          return not vim.endswith(f, 'init.lua')
        end
      end)
      :map(function(f) return vim.fn.fnamemodify(f, ':r:s?^.*/lua/??') end)
      :totable()
  end,
  ['fs.dir + table.insert'] = function()
    local results = {}
    for name, type in vim.fs.dir(dir) do
      local path = dir .. name
      if type == 'directory' then
        if vim.uv.fs_stat(path .. '/init.lua') then
          table.insert(results, 'nvim/' .. name)
        end
      elseif type == 'file' and name:match('%.lua$') and name ~= 'init.lua' then
        table.insert(results, 'nvim/' .. name:gsub('%.lua$', ''))
      end
    end
    return results
  end,
  ['readdir + tbl_map'] = function()
    return vim.tbl_map(
      function(name) return 'nvim/' .. name:gsub('%.lua$', '') end,
      vim.fn.readdir(
        dir,
        function(name)
          return (
            (vim.fn.isdirectory(dir .. name) == 1 and vim.uv.fs_stat(dir .. name .. '/init.lua'))
            or (name:match('%.lua$') and name ~= 'init.lua')
          )
              and 1
            or 0
        end
      )
    )
  end,
  ['fs.dir + iter'] = function()
    return vim
      .iter(vim.fs.dir(dir))
      :filter(function(name, type_)
        local path = dir .. name
        if type_ == 'directory' then
          return vim.uv.fs_stat(path .. '/init.lua') ~= nil
        else
          return name:match('%.lua$') and name ~= 'init.lua'
        end
      end)
      :map(function(name) return 'nvim/' .. name:gsub('%.lua$', '') end)
      :totable()
  end,
})
