--- NOTE: oil.nvim and render-markdown.nvim both use mini icons
local icons = {
  default = {},
  directory = {},
  extension = {},
  file = {},
  filetype = {},
  lsp = {},
  os = {},
}

--- @param k "file"|"extension"|"filetype"
--- @param v string
--- @param glyph string the actual icon
--- @param color? string optional MiniIconColor
local add = function(k, v, glyph, color)
  icons[k][v] = { glyph = glyph, hl = 'MiniIcons' .. color }
end

add('file', '.keep', '󰊢 ', 'Grey')
add('file', 'devcontainer.json', '', 'Azure')

local ft_map = {
  json = ' ',
  sh = ' ',
  toml = ' ',
  zsh = ' ',
}

-- add chezmoi template extensions
for ext in string.gmatch('json sh toml zsh', '%S+') do
  add('extension', ext .. '.tmpl', ft_map[ext], 'Grey')
end

-- add chezmoi special files
for file in string.gmatch('ignore remove root version', '%S+') do
  add('file', '.chezmoi' .. file, '', 'Grey')
end

-- add chezmoi hidden files
for file in string.gmatch('zshrc zshenv zprofile zshprofile', '%S+') do
  add('file', 'dot_' .. file, ' ', 'Green')
end

add('file', 'dot_Rprofile', '󰟔 ', 'Blue')
add('file', 'dot_bash_aliases', ' ', 'Blue')

local todo = {
  { 'extension', 'fastq', '󰚄', 'Purple' },
  { 'extension', 'fastq.gz', '󰚄', 'Red' },
  { 'filetype', 'dotenv', ' ', 'Yellow' },
  { 'filetype', 'snacks_terminal', '🍬', '' },
  { 'filetype', 'nvim-pack', '', 'Green' },
  -- HACK: treesitter status icons
  { 'filetype', 'printf', '', 'Orange' },
  { 'filetype', 'regex', '', 'Orange' },
}

for _, v in ipairs(todo) do
  add(v[1], v[2], v[3], v[4])
end

return icons
