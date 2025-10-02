-- see `:h vim.pack` for more information on the new package manager
--- @alias PackEvents "PackChangedPre" | "PackChanged"

--- @class PackChangedEventData
--- @field kind "install" | "update" | "delete"
--- @field spec vim.pack.Spec
--- @field path string

--- Helper to report build results
--- @param name string
--- @param ok boolean true if build succeeded, false if failed
--- @param err? string optional error or output
local function notify_build(name, ok, err)
  local msg = 'Build '
    .. (ok and 'succeeded' or 'failed')
    .. ' for '
    .. name
    .. (err and (': ' .. err) or '')
  Snacks.notify(msg, ok and 'info' or 'error')
end

-- TODO: fix the function signature
--- Setup an autocmd to trigger a build command when the plugin is updated
--- @param name string The name of the plugin to track
--- @param build string|fun():string The build command or function to run
return function(name, build)
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(event)
      local data = event.data
      if data.kind ~= 'update' then
        return
      end

      -- local build = spec and data.spec and data.spec.build
      if not build then
        return
      end

      if vim.is_callable(build) then
        local ok, result = pcall(build)
        -- dd(name, ok, ok and nil or result)
      elseif type(build) == 'string' then
        local cmd = string.format('cd %s && %s', vim.fn.shellescape(data.spec.dir), build)
        local output = vim.fn.system(cmd)
        -- dd(name, vim.v.shell_error == 0, vim.v.shell_error ~= 0 and output or nil)
      else
        -- dd(name, false, 'Invalid build command type: ' .. type(build))
      end
    end,
  })
end
