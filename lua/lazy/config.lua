return {
  icons = {
    -- ft = { octo = ' ' },
    git = {
      added = ' ',
      modified = ' ',
      removed = ' ',
    },
    kinds = require('snacks.picker.config.defaults').defaults.icons.kinds,
    misc = { dots = '…' },
  },
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
  emojis = {
    -- stylua: ignore
    lazu_ui = {
      -- cmd     = '⌘',
      cmd     = '🖥️',
      config  = '🛠',
      event   = '📅',
      ft      = '📂',
      -- init    = '⚙',
      init    = '🏁',
      keys    = '🗝',
      plugin  = '🔌',
      runtime = '💻',
      require = '🌙',
      source  = '📄',
      start   = '🚀',
      task    = '📌',
      lazy    = '💤 ',
    },
  },
}
