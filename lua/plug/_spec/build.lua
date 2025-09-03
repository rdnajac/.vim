-- see `:h vim.pack` for more information on the new package manager
--- @alias PackEvents "PackChangedPre" | "PackChanged"

--- @class PackChangedEventData
--- @field kind "install" | "update" | "delete"
--- @field spec vim.pack.Spec
--- @field path string

--- Helper to report build results
--- @param plugin_name string
--- @param ok boolean true if build succeeded, false if failed
--- @param err? string optional error or output
local function notify_build(plugin_name, ok, err)
  local msg = 'Build '
    .. (ok and 'succeeded' or 'failed')
    .. ' for '
    .. plugin_name
    .. (err and (': ' .. err) or '')
  Snacks.notify(msg, ok and 'info' or 'error')
end

-- TODO: fix the function signature
--- Setup an autocmd to trigger a build command when the plugin is updated
--- @param plugin_name string The name of the plugin to track
--- @param build string|fun():string The build command or function to run
local function build(plugin_name, build)
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(event)
      local data = event.data
      if data.kind ~= 'update' then
        return
      end

      local spec = data.spec
      if not spec or spec.name ~= plugin_name then
        return
      end

      if vim.is_callable(build) then
        local ok, result = pcall(build)
        notify_build(plugin_name, ok, ok and nil or result)
      elseif type(build) == 'string' then
        local cmd = string.format('cd %s && %s', vim.fn.shellescape(spec.dir), build)
        local output = vim.fn.system(cmd)
        notify_build(plugin_name, vim.v.shell_error == 0, vim.v.shell_error ~= 0 and output or nil)
      else
        notify_build(plugin_name, false, 'Invalid build command type: ' .. type(build))
      end
    end,
  })
end
