local fn = function() error('test error') end

local ok, err = xpcall(require, debug.traceback)
if not ok then
  vim.schedule(function() vim.notify(err, vim.log.levels.ERROR) end)
end
