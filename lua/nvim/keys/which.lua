
local M = {}
local default_colors = {
  -- WhichKey          = { fg = c.cyan },
  [''] = 'Function', -- the key
  -- WhichKeySeparator = { fg = c.comment },
  Separator = 'Comment', -- the separator between the key and its description
  -- WhichKeyGroup     = { fg = c.blue },
  Group = 'Keyword', -- group name
  -- WhichKeyDesc      = { fg = c.magenta },
  Desc = 'Identifier', -- description
  -- WhichKeyNormal     = { bg = c.bg_sidebar },
  Normal = 'NormalFloat', -- Normal in th which-key window
  -- WhichKeyValue     = { fg = c.dark5 },
  Value = 'Comment', -- values by plugins (like marks, registers, etc)

  Border = 'FloatBorder', -- Border of the which-key window
  Title = 'FloatTitle', -- Title of the which-key window

  --- which-key/icons
  Icon = '@markup.link', -- icons
  IconAzure = 'Function',
  IconBlue = 'DiagnosticInfo',
  IconCyan = 'DiagnosticHint',
  IconGreen = 'DiagnosticOk',
  IconGrey = 'Normal',
  IconOrange = 'DiagnosticWarn',
  IconPurple = 'Constant',
  IconRed = 'DiagnosticError',
  IconYellow = 'DiagnosticWarn',
}

return M
