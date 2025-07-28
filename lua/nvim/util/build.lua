-- TODO: build only on first load
-- M:Build()

-- Available events to hook into ~
-- • *PackChangedPre* - before trying to change plugin's state.
-- • *PackChanged* - after plugin's state has changed.
--
-- Each event populates the following |event-data| fields:
-- • `kind` - one of "install" (install on disk), "update" (update existing
--   plugin), "delete" (delete from disk).
-- • `spec` - plugin's specification.
-- • `path` - full path to plugin's directory.
local async = require('vim._async')

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec and ev.data.spec.name
    local build_cmd = M[name] and M[name].build
    print(vim.inspect(ev))
    print(name)
    print(build_cmd)
    async.run(function()
      local output = vim.fn.system(build_cmd)
      local err = vim.v.shell_error ~= 0 and output or nil
      return err, output
    end, function(err, output)
      if err then
        vim.notify('Build error for ' .. name .. ': ' .. err, vim.log.levels.ERROR)
      else
        vim.notify('Build succeeded for ' .. name)
      end
    end)
  end,
})

-- function M:Build()
--   for _, spec in ipairs(M) do
--     if spec.build then
--       if type(spec.build) == 'string' then
--         vim.fn.system(spec.build)
--       elseif type(spec.build) == 'function' then
--         spec.build()
--       end
--     end
--   end
-- end
