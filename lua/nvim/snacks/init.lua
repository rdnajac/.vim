local M = { 'folke/snacks.nvim' }

---@module "snacks"
---@type snacks.Config
local opts = {
  bigfile = { enabled = true },
  dashboard = { enabled = false },
  explorer = { enabled = true },
  image = { enabled = false },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = false },
  words = { enabled = true },
}

M.opts = vim.tbl_deep_extend('force', opts, require('nvim.snacks.config'))

M.config = function()
  require('snacks').setup(M.opts)
end

return M
