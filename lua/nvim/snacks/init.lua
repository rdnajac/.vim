local M = { 'folke/snacks.nvim' }

---@module "snacks"
---@type snacks.Config
M.opts = {
  bigfile = { enabled = true },
  dashboard = { enabled = true },
  explorer = { enabled = true },
  image = { enabled = false },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = false },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  -- TODO: 
  statuscolumn = { enabled = false },
  words = { enabled = true },
}

M.config = function()
  M.opts = vim.tbl_deep_extend('force', M.opts, require('nvim.snacks.config'))
  require('snacks').setup(M.opts)
end

return M
