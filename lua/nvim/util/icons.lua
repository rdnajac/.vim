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
  copilot = { -- sidekick.nvim lualine components
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
  fticon = function(bufnr_or_ft)
    local ft = type(bufnr_or_ft) == 'string' and bufnr_or_ft or nil
    if not ft then
      local bufnr = bufnr_or_ft or vim.api.nvim_get_current_buf()
      ft = vim.bo[bufnr].filetype
    end
    return (MiniIcons and MiniIcons.get('filetype', ft) or ' ') .. ' '
  end,
}

local snacks_icons = require('snacks.picker.config.defaults').defaults.icons
local ret = vim.tbl_deep_extend('force', {}, icons, snacks_icons)

-- add an inverted lookup table for kinds

if ret.kinds then
  for name, num in pairs(vim.lsp.protocol.SymbolKind) do
    if type(name) == 'string' and ret.kinds[name] then
      ret.kinds[num] = ret.kinds[name]
    end
  end
end

-- return ret
return setmetatable(ret, {
  -- __index = function(_, key)
  --   if key == 'kinds' then
  --     -- add an inverted lookup table for kinds on first access
  --     local kinds = ret.kinds or {}
  --     for name, num in pairs(vim.lsp.protocol.symbolkind) do
  --       if type(name) == 'string' and kinds[name] then
  --         kinds[num] = kinds[name]
  --       end
  --     end
  --     ret.kinds = kinds
  --     return kinds
  --   end
  --   return ret[key]
  -- end,
  __call = function(_, key)
    return ret.fticon(key)
  end,
})
