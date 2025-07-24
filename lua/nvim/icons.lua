return {
  blink_src = {
  buffer = ' ',
  cmdline = ' ',
  env = '$ ',
  lazydev = '󰒲 ',
  lsp = ' ',
  omni = ' ',
  path = ' ',
  snippets = ' '
  -- snippets = icons.kinds.Snippet,
},
  diagnostics = {
    error = ' ',
    warn = ' ',
    hint = '',
    info = ' ',
  },
  ft = { octo = ' ' },
  git = {
    added = ' ',
    modified = ' ',
    removed = ' ',
  },
  -- kinds from snacks
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
