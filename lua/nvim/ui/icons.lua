local M = {}

M = {
  ft = { octo = ' ' },
  git = {
    added = ' ',
    modified = ' ',
    removed = ' ',
  },
  kinds = require('snacks.picker.config.defaults').defaults.icons.kinds,
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
