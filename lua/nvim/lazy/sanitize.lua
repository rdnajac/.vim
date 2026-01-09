-- sanitize lazy spec entries for my pluginmanager
local M = setmetatable({}, {
  __call = function(M, ...)
    return M.sanitize(...)
  end,
})

function M.sanitize(plugin)
  -- handle `config = true` without opts
  if not plugin.opts and plugin.config == true then
    plugin.opts = {}
  end

  -- handle `LazyFile` event from `LazyVim`
  if plugin.lazy == true or plugin.event == 'LazyFile' then
    plugin.event = require('nvim.lazy.file').events
  end

  return plugin
end

return M
