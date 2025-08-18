local icons = {
  src = {
    buffer = ' ',
    cmdline = ' ',
    copilot = ' ',
    env = '$ ',
    lazydev = '󰒲 ',
    lsp = ' ',
    omni = ' ',
    path = ' ',
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
local ok, mod = pcall(require, 'snacks.picker.config.defaults')
if ok then
  local snacks_icons = mod.defaults.icons

  icons = vim.tbl_deep_extend('force', icons, snacks_icons)
end

-- Attach metatable to icons.kinds
if icons.kinds then
  -- Mirror string → numeric SymbolKind
  for name, num in pairs(vim.lsp.protocol.SymbolKind) do
    if type(name) == 'string' and icons.kinds[name] then
      icons.kinds[num] = icons.kinds[name]
    end
  end

  -- Fallback handler from `navic`
  setmetatable(icons.kinds, {
    __index = function(_, key)
      return "? " .. tostring(key)
    end,
  })
end

return icons
