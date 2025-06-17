return {
  icons = {
    -- ft = { octo = ' ' },
    diagnostics = {
      error = '🔥',
      warn = '💩',
      hint = '🧠',
      info = '👾',
    },
    git = {
      added = ' ',
      modified = ' ',
      removed = ' ',
    },
    kinds = require('snacks.picker.config.defaults').defaults.icons.kinds,
    misc = { dots = '…' },
  },
}
