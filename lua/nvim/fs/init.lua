local nv = _G.nv or require('nvim.util')
local M = {}

M.specs = {
  {
    'stevearc/oil.nvim',
    enabled = true,
    keys = { { '-', '<Cmd>Oil<CR>' } },
    opts = {
      default_file_explorer = false,
    },
  },
}

M.after = function()
  -- bt()
end

return M
