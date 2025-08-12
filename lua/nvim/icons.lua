local icons = {
  blink_src = {
    buffer = ' ',
    cmdline = ' ',
    env = '$ ',
    lazydev = '󰒲 ',
    lsp = ' ',
    omni = ' ',
    path = ' ',
    snippets = ' ',
    -- snippets = icons.kinds.Snippet,
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


local ok, defaults = pcall(require, 'snacks.picker.config.defaults')
if ok then
  icons = vim.tbl_deep_extend('force', icons, defaults.defaults.icons)
end

return icons
