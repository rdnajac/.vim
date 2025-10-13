--   package.preload['nvim-web-devicons'] = function()
--     require('mini.icons').mock_nvim_web_devicons()
--     return package.loaded['nvim-web-devicons']
--   end
local M = {}

local icons = {
  src = { -- blink sources
    buffer = ' ',
    cmdline = ' ',
    copilot = ' ',
    env = ' ',
    lazydev = '󰒲 ',
    lsp = ' ',
    omni = ' ',
    path = ' ',
    snippets = ' ',
    cmp_r = ' ',
  },
  mason = {
    package_installed = '✓',
    package_pending = '➜',
    package_uninstalled = '✗',
  },
  os = { -- from nvim-lualine/lualine.nvim
    unix = '', -- e712
    dos = '', -- e70f
    mac = '', -- e711
  },
  separators = { -- useful in statuslines
    component = {
      angle = { left = '', right = '' },
      rounded = { left = '', right = '' },
    },
    section = {
      angle = { left = '', right = '' },
      rounded = { left = '', right = '' },
    },
  },
  ---@module "sidekick"
  ---@type table <sidekick.lsp.Status.kind, { icon: string, hl: string }>
  copilot = {
    Error = { ' ', 'DiagnosticError' },
    Inactive = { ' ', 'MsgArea' },
    Warning = { ' ', 'DiagnosticWarn' },
    Normal = { ' ', 'Special' },
  },
  mini = { -- for mini.icon opts
    file = {
      ['.keep'] = { glyph = '󰊢', hl = 'MiniIconsGrey' },
      ['devcontainer.json'] = { glyph = '', hl = 'MiniIconsAzure' },
      ['dot_zshrc'] = { glyph = '', hl = 'MiniIconsGreen' },
      ['dot_zshenv'] = { glyph = '', hl = 'MiniIconsGreen' },
      ['dot_zprofile'] = { glyph = '', hl = 'MiniIconsGreen' },
      ['dot_zshprofile'] = { glyph = '', hl = 'MiniIconsGreen' },
      ['.chezmoiignore'] = { glyph = '', hl = 'MiniIconsGrey' },
      ['.chezmoiremove'] = { glyph = '', hl = 'MiniIconsGrey' },
      ['.chezmoiroot'] = { glyph = '', hl = 'MiniIconsGrey' },
      ['.chezmoiversion'] = { glyph = '', hl = 'MiniIconsGrey' },
      ['bash.tmpl'] = { glyph = '', hl = 'MiniIconsGrey' },
      ['json.tmpl'] = { glyph = '', hl = 'MiniIconsGrey' },
      ['sh.tmpl'] = { glyph = '', hl = 'MiniIconsGrey' },
      ['toml.tmpl'] = { glyph = '', hl = 'MiniIconsGrey' },
      ['zsh.tmpl'] = { glyph = '', hl = 'MiniIconsGrey' },
    },
    extension = {
      ['fastq'] = { glyph = '󰚄 ', hl = 'MiniIconsPurple' },
      ['fastq.gz'] = { glyph = '󰚄 ', hl = 'MiniIconsRed' },
    },
    filetype = {
      dotenv = { glyph = '', hl = 'MiniIconsYellow' },
    },
  },
}

local snacks_icons = require('snacks.picker.config.defaults').defaults.icons
M = vim.tbl_deep_extend('force', {}, icons, snacks_icons)

-- add an inverted lookup table for kinds
for name, num in pairs(vim.lsp.protocol.SymbolKind) do
  if type(name) == 'string' and M.kinds[name] then
    M.kinds[num] = M.kinds[name]
  end
end

local fticon = function(bufnr_or_ft)
  local ft = type(bufnr_or_ft) == 'string' and bufnr_or_ft or nil
  if not ft then
    local bufnr = bufnr_or_ft or vim.api.nvim_get_current_buf()
    ft = vim.bo[bufnr].filetype
  end
  return (MiniIcons and MiniIcons.get('filetype', ft) or ' ') .. ' '
end

return setmetatable(M, {
  __call = function(_, key)
    return fticon(key)
  end,
})
