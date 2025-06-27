local M = {}

M.diagnostics = {
      error = '🔥',
      warn = '💩',
      hint = '🧠',
      info = '👾',
    }

M.kinds = require('snacks.picker.config.defaults').defaults.icons.kinds

return M
