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
  -- for mini.icon opts
  mini = {
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
nv.icons = vim.tbl_deep_extend('force', icons, snacks_icons)
-- add an inverted lookup table for kinds
if nv.icons.kinds then
  for name, num in pairs(vim.lsp.protocol.SymbolKind) do
    if type(name) == 'string' and nv.icons.kinds[name] then
      nv.icons.kinds[num] = nv.icons.kinds[name]
    end
  end
end

return icons
