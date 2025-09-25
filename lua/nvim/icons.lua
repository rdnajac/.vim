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
}

local snacks_icons = require('snacks.picker.config.defaults').defaults.icons
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

return setmetatable(icons, {
  -- TODO: use __index to return fticons conditionally
  __call = function(_, bufnr_or_ft)
    local ft
    if type(bufnr_or_ft) == 'string' then
      ft = bufnr_or_ft
    else
      local bufnr = bufnr_or_ft or vim.api.nvim_get_current_buf()
      ft = vim.bo[bufnr].filetype
    end

    if type(ft) ~= 'string' or ft == '' then
      return ' '
    end

    local ok, icon = pcall(require('mini.icons').get, 'filetype', ft)
    if not ok or not icon then
      icon = ' '
    end
    return icon .. ' '
  end,
})
