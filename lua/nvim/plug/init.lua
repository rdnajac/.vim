local M = {}

local Plugin = require('nvim.plug.oop')
M.__call = Plugin.new

-- specs collected from vimrc
M.specs = vim.g.pluglist

-- get all unloaded plugins
M.unloaded = function()
  return vim
    .iter(vim.pack.get())
    --- @param plugin vim.pack.PlugData
    :filter(function(plugin)
      return plugin.active == false
    end)
    --- @param plugin vim.pack.PlugData
    :map(function(plugin)
      return plugin.spec.name
    end)
    :totable()
end

M.commands = function()
  local command = vim.api.nvim_create_user_command

  command('PlugUpdate', function(opts)
    local plugs = #opts.fargs > 0 and opts.fargs or nil
    vim.pack.update(plugs, { force = opts.bang })
  end, {
    nargs = '*',
    bang = true,
    complete = function()
      return vim.tbl_map(function(p)
        return p.spec.name
      end, vim.pack.get())
    end,
  })

  -- TODO: take optional names with a completion list
  command('PlugStatus', function(opts)
    local plugin = nv.util.is_nonempty_string(opts.fargs) and opts.fargs or nil
    vim._print(true, vim.pack.get(plugin, { info = opts.bang }))
  end, {
    bang = true,
    nargs = '*',
    complete = function()
      return vim.tbl_map(function(p)
        return p.spec.name
      end, vim.pack.get())
    end,
  })

  command('PlugClean', function(opts)
    local plugs = #opts.fargs > 0 and opts.fargs or M.unloaded()
    vim.pack.del(plugs)
  end, {
    nargs = '*',
    complete = function(_, _, _)
      return M.unloaded()
    end,
  })
end


-- return setmetatable(M, {
--   __call = function(_, argv0)
--     print(argv0)
--     return Plugin.new(argv0)
--   end,
-- })

return M
