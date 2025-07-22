local ok, snacks_defaults = pcall(require, 'snacks.picker.config.defaults')
local kinds = ok and snacks_defaults.defaults.icons.kinds or {}

local M = {
  kinds = kinds,
  ft = { octo = ' ' },
  git = {
    added = ' ',
    modified = ' ',
    removed = ' ',
  },
  misc = { dots = '…' },
  separators = {
    component = {
      angle = { left = '', right = '' },
      rounded = { left = '', right = '' },
    },
    section = {
      angle = { left = '', right = '' },
      rounded = { left = '', right = '' },
    },
  },
}

return M
