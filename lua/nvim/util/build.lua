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

-- XXX: experimental module for
local async = require('vim._async')

--- Execute a shell command and return its output and error state.
--- @param cmd string
--- @return string output, string|nil err
local function run_cmd(cmd)
  local output = vim.fn.system(cmd)
  local err = vim.v.shell_error ~= 0 and output or nil
  return output, err
end

--- Run a build command or function in the specified path.
--- @param build string|fun():string
--- @param path string
--- @return string|nil output, string|nil err
local function run_build(build, path)
  if type(build) == 'function' then
    local ok, result = pcall(build)
    return result, not ok and result or nil
  elseif type(build) == 'string' then
    local cmd = string.format('cd %s && %s', vim.fn.shellescape(path), build)
    return run_cmd(cmd)
  else
    return nil, 'Invalid build command type: ' .. type(build)
  end
end

--- @param name string
--- @param build string|fun():string
--- @param output string
--- @param err string|nil
local function notify_build(name, build, output, err)
  Snacks.notify.info('Building plugin ' .. name .. ' with command: ' .. tostring(build))
  Snacks.notify.info('Output: ' .. output)
  if err then
    Snacks.notify.error('Build error for ' .. name .. ': ' .. err)
  else
    Snacks.notify.info('Build succeeded for ' .. name)
  end
end

vim.api.nvim_create_autocmd('PackChanged', {
  --- @param ev { data: { kind: string, path: string, spec: { name: string } } }
  callback = function(ev)
    if ev.data.kind ~= 'update' then
      return
    end
    local name = ev.data.spec and ev.data.spec.name
    local build_cmd = M[name] and M[name].build
    if not build_cmd then
      return
    end
    async.run(function()
      local output, err = run_build(build_cmd, ev.data.path)
      notify_build(ev.data.spec.name, build_cmd, output, err)
    end)
  end,
})
