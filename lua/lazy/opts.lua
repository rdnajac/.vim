return {
  icons = {
    misc = { dots = '󰇘' },
    ft = { octo = ' ' },
    diagnostics = {
      Error = '🔥',
      Warn = '💩',
      Hint = '🧠',
      Info = '👾',
    },
    git = {
      added = ' ',
      modified = ' ',
      removed = ' ',
    },
    kinds = require('snacks.picker.config.defaults').defaults.icons.kinds,
  },
  ---@type table<string, string[]|boolean>?
  kind_filter = {
    default = {
      'Class',
      'Constructor',
      'Enum',
      'Field',
      'Function',
      'Interface',
      'Method',
      'Module',
      'Namespace',
      'Package',
      'Property',
      'Struct',
      'Trait',
    },
    markdown = false,
    help = false,
    -- you can specify a different filter for each filetype
    lua = {
      'Class',
      'Constructor',
      'Enum',
      'Field',
      'Function',
      'Interface',
      'Method',
      'Module',
      'Namespace',
      -- "Package", -- remove package since luals uses it for control flow structures
      'Property',
      'Struct',
      'Trait',
    },
  },
}
