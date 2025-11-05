local directory = {
  ghostty = { '󰊠', 'Green' },
}

local extension = {
  fastq = { '󰚄', 'Purple' },
  ['fastq.gz'] = { '󰚄', 'Red' },
  ['json.tmpl'] = { ' ', 'Grey' },
  ['sh.tmpl'] = { ' ', 'Grey' },
  ['toml.tmpl'] = { ' ', 'Grey' },
  ['zsh.tmpl'] = { ' ', 'Grey' },
}

local file = {
  ['.chezmoiignore'] = { '', 'Grey' },
  ['.chezmoiremove'] = { '', 'Grey' },
  ['.chezmoiroot'] = { '', 'Grey' },
  ['.chezmoiversion'] = { '', 'Grey' },
  ['.keep'] = { '󰊢 ', 'Grey' },
  ['devcontainer.json'] = { '', 'Azure' },
  dot_Rprofile = { '󰟔 ', 'Blue' },
  dot_bash_aliases = { ' ', 'Blue' },
  dot_zprofile = { ' ', 'Green' },
  dot_zshenv = { ' ', 'Green' },
  dot_zshprofile = { ' ', 'Green' },
  dot_zshrc = { ' ', 'Green' },
  ['ghostty/config'] = { '👻', 'Green' },
}

local filetype = {
  dotenv = { ' ', 'Yellow' },
  ['nvim-pack'] = { '', 'Green' },
  printf = { '', 'Orange' },
  regex = { '', 'Orange' },
  sidekick_terminal = { ' ', '' },
  snacks_dashboard = { '󰨇 ', '' },
  snacks_terminal = { '🍬', '' },
}

local function make_opts(v)
  return { glyph = v[1], hl = 'MiniIcons' .. v[2] }
end

local M = {
  directory = vim.tbl_map(make_opts, directory),
  extension = vim.tbl_map(make_opts, extension),
  file = vim.tbl_map(make_opts, file),
  filetype = vim.tbl_map(make_opts, filetype),
}

M.use_file_extension = function(ext, _)
  return ext:sub(-3) ~= 'scm'
end

M.test = function()
  local tests = {
    directory = { 'ghostty', 'src', 'mini.nvim' },
    file = {
      '.chezmoiignore',
      'devcontainer.json',
      'somefile.fastq.gz',
      'dot_Rprofile',
      'test.lua',
      'README.md',
    },
  }
  for kind, names in pairs(tests) do
    for _, name in ipairs(names) do
      local icon, hl = MiniIcons.get(kind, name)
      print(string.format('[%s] %s -> %s (%s)', kind, name, icon, hl))
    end
  end
end

return M
