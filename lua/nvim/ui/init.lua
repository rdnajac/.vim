local M = vim.defaulttable(function(k)
  return require('ui.' .. k)
end)


M.specs = {
  -- 'folke/noice.nvim',
  -- 'jhui/fidget.nvim',
}

M.config = function()
  require('nvim.ui.winbar')
  vim.o.winbar = '%{%v:lua.MyWinBar()%}'
end

-- TODO: make default tables set these values to empty tables so
-- the loading mechanism stops freaking out
M.keys = {}
function M.after() end

return M
