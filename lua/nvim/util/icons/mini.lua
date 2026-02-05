-- opts for MiniIcons
local opts = {
  directory = {
    ghostty = { '󰊠', 'Green' },
    LazyVim = { '󰒲', 'Blue' },
    ['R.nvim'] = { '󰟔', 'Cyan' },
  },
  extension = {
    fastq = { '󰚄', 'Purple' },
    ['fastq.gz'] = { '󰚄', 'Red' },
    ['json.tmpl'] = { ' ', 'Grey' },
    ['sh.tmpl'] = { ' ', 'Grey' },
    ['toml.tmpl'] = { ' ', 'Grey' },
    ['zsh.tmpl'] = { ' ', 'Grey' },
  },
  file = {
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
    -- ['ghostty/config'] = { '👻', 'Green' },
  },

  filetype = {
    dotenv = { ' ', 'Yellow' },
    ghostty = { '👻', 'Green' },
    ['nvim-pack'] = { '', 'Green' },
    printf = { '', 'Orange' },
    regex = { '', 'Orange' },
    sidekick_terminal = { ' ', '' },
    snacks_dashboard = { '󰨇 ', '' },
    snacks_terminal = { '🍬', '' },
  },
}

local function map_fn(pair) return { glyph = pair[1], hl = 'MiniIcons' .. pair[2] } end

for opt, v in pairs(opts) do
  opts[opt] = vim.tbl_map(map_fn, v)
end

opts.use_file_extension = function(ext, _) return ext:sub(-3) ~= 'scm' end

local directories_override = {
  ['vim%-.*'] = { '', 'Green' },
  ['lazy.*%.nvim'] = { '󰒲', 'Blue' },
}

-- HACK: Override to use wildcard matching for directories
vim.schedule(function()
  local original_get = MiniIcons.get
  ---@diagnostic disable-next-line: duplicate-set-field
  MiniIcons.get = function(category, name)
    if category == 'directory' then
      local dir = vim.fs.basename(name)
      for pattern, pair in pairs(directories_override) do
        -- add anchors to pattern for exact match
        if dir:match('^' .. pattern .. '$') then
          return pair[1], 'MiniIcons' .. pair[2]
        end
      end
    end
    return original_get(category, name)
  end
end)

return opts
