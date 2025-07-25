-- lua/nvim/lazy.lua
local aug = vim.api.nvim_create_augroup('LazyLoad', { clear = true })
local async = require('vim._async')

local M = {}

function M.config(plugin)
  if plugin.event then
    vim.api.nvim_create_autocmd(plugin.event, {
      group = aug,
      once = true,
      callback = plugin.config,
    })
  else
    plugin.config()
  end
end

function M.build(name, plugin, tbl)
  if not plugin.build then
    return
  end
  vim.api.nvim_create_autocmd('PackChanged', {
    group = aug,
    once = true,
    callback = function(ev)
      local changed = ev.data.spec and ev.data.spec.name
      if changed ~= name then
        return
      end
      local cmd = tbl[name] and tbl[name].build
      if type(cmd) == 'string' then
        async.run(function()
          local out = vim.fn.system(cmd)
          local err = vim.v.shell_error ~= 0 and out or nil
          return err, out
        end, function(err, out)
          if err then
            vim.notify('Build error for ' .. name .. ': ' .. err, vim.log.levels.ERROR)
          else
            vim.notify('Build succeeded for ' .. name)
          end
        end)
      end
    end,
  })
end

function M.dep(_) end

return M
