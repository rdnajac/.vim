local M =  vim.defaulttable(function(k)
  return require('nvim.' .. k)
end)

_G.nvim = M

-- nvim.info = function(msg, opts)
--   vim.notify(msg, vim.log.levels.INFO, opts or {})
-- end

return M
