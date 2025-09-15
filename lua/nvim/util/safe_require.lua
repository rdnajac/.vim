local M = {}

-- Override require to handle errors gracefully
M.safe_require = function(module, err)
  local ok, mod = xpcall(require, debug.traceback, module)
  if not ok then
    vim.schedule(function()
      if err == true then
        error(mod)
      else
        vim.notify(('Failed to load %s:\n%s'):format(module, mod), vim.log.levels.WARN)
      end
    end)
    return nil
  end
  return mod
end


return setmetatable(M, {
  __call = M.safe_require,
})
