ddd('lazy/opts')
---@class LazyVimOptions
return {
  -- colorscheme = function()
  --   ddd('init colorscheme')
  --   local colorscheme = require('config.lazy.spec.colorscheme').opts
  --   -- vim.opt.rtp:append(vim.fn.stdpath('data') .. '/lazy/tokyonight.nvim/')
  --   require('tokyonight').load(colorscheme)
  -- end,
  defaults = {
    autocmds = false,
    keymaps = false,
  },
  news = {
    lazyvim = false,
    neovim = false,
  },
  -- icons used by other plugins
  icons = {
    misc = { dots = '󰇘' },
    ft = { octo = '' },
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
    -- stylua: ignore
    kinds = {
      Array         = " ",
      Boolean       = "󰨙 ",
      Class         = " ",
      Codeium       = "󰘦 ",
      Color         = " ",
      Control       = " ",
      Collapsed     = " ",
      Constant      = "󰏿 ",
      Constructor   = " ",
      Copilot       = " ",
      Enum          = " ",
      EnumMember    = " ",
      Event         = " ",
      Field         = " ",
      File          = " ",
      Folder        = " ",
      Function      = "󰊕 ",
      Interface     = " ",
      Key           = " ",
      Keyword       = " ",
      Method        = "󰊕 ",
      Module        = " ",
      Namespace     = "󰦮 ",
      Null          = " ",
      Number        = "󰎠 ",
      Object        = " ",
      Operator      = " ",
      Package       = " ",
      Property      = " ",
      Reference     = " ",
      Snippet       = "󱄽 ",
      String        = " ",
      Struct        = "󰆼 ",
      Supermaven    = " ",
      TabNine       = "󰏚 ",
      Text          = " ",
      TypeParameter = " ",
      Unit          = " ",
      Value         = " ",
      Variable      = "󰀫 ",
    },
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
