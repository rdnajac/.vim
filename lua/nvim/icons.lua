local icons = {
  src = {
    buffer = ' ',
    cmdline = ' ',
    copilot = ' ',
    codecompanion = ' ',
    env = '$ ',
    lazydev = '󰒲 ',
    lsp = ' ',
    omni = ' ',
    path = ' ',
    snippets = ' ',
    cmp_r = ' ',
  },
  ft = { octo = ' ' },
  misc = { dots = '…' },
  os = { -- from nvim-lualine/lualine.nvim
    unix = '', -- e712
    dos = '', -- e70f
    mac = '', -- e711
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
}

-- Try to load defaults from snacks.picker
-- contains: lspkinds, git, diagnostics, etc.
local snacks_icons = {}
local ok, mod = pcall(require, 'snacks.picker.config.defaults')
if ok then
  snacks_icons = mod.defaults.icons
else
  snacks_icons = {
    files = {
      enabled = true, -- show file icons
      dir = '󰉋 ',
      dir_open = '󰝰 ',
      file = '󰈔 ',
    },
    keymaps = {
      nowait = '󰓅 ',
    },
    tree = {
      vertical = '│ ',
      middle = '├╴',
      last = '└╴',
    },
    undo = {
      saved = ' ',
    },
    ui = {
      live = '󰐰 ',
      hidden = 'h',
      ignored = 'i',
      follow = 'f',
      selected = '● ',
      unselected = '○ ',
      -- selected = " ",
    },
    git = {
      enabled = true, -- show git icons
      commit = '󰜘 ', -- used by git log
      staged = '●', -- staged changes. always overrides the type icons
      added = '',
      deleted = '',
      ignored = ' ',
      modified = '○',
      renamed = '',
      unmerged = ' ',
      untracked = '?',
    },
    diagnostics = {
      Error = ' ',
      Warn = ' ',
      Hint = ' ',
      Info = ' ',
    },
    lsp = {
      unavailable = '',
      enabled = ' ',
      disabled = ' ',
      attached = '󰖩 ',
    },
    kinds = {
      Array = ' ',
      Boolean = '󰨙 ',
      Class = ' ',
      Color = ' ',
      Control = ' ',
      Collapsed = ' ',
      Constant = '󰏿 ',
      Constructor = ' ',
      Copilot = ' ',
      Enum = ' ',
      EnumMember = ' ',
      Event = ' ',
      Field = ' ',
      File = ' ',
      Folder = ' ',
      Function = '󰊕 ',
      Interface = ' ',
      Key = ' ',
      Keyword = ' ',
      Method = '󰊕 ',
      Module = ' ',
      Namespace = '󰦮 ',
      Null = ' ',
      Number = '󰎠 ',
      Object = ' ',
      Operator = ' ',
      Package = ' ',
      Property = ' ',
      Reference = ' ',
      Snippet = '󱄽 ',
      String = ' ',
      Struct = '󰆼 ',
      Text = ' ',
      TypeParameter = ' ',
      Unit = ' ',
      Unknown = ' ',
      Value = ' ',
      Variable = '󰀫 ',
    },
  }
end

-- merge the tables
icons = vim.tbl_deep_extend('force', icons, snacks_icons)

-- add an inverted lookup table for kinds
if icons.kinds then
  for name, num in pairs(vim.lsp.protocol.SymbolKind) do
    if type(name) == 'string' and icons.kinds[name] then
      icons.kinds[num] = icons.kinds[name]
    end
  end
end

return icons
