---@module "snacks"
---@type snacks.Config
local enabled = {
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

-- TODO: merge all opts, without nested requires
local opts = vim.tbl_deep_extend('force', enabled, require('nvim.snacks.config'))

require('snacks').setup(opts)
