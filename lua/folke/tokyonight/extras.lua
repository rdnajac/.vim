-- see `$PACKDIR/tokyonight.nvim/lua/tokyonight/extra/`

---@type table<string, {ext:string, url:string, label:string, subdir?: string, sep?:string}>
local extras = {
  eza = { ext = 'yml', url = 'https://eza.rocks', label = 'eza' },
  fish = { ext = 'fish', url = 'https://fishshell.com/docs/current/index.html', label = 'Fish' },
  fish_themes = {
    ext = 'theme',
    url = 'https://fishshell.com/docs/current/interactive.html#syntax-highlighting',
    label = 'Fish Themes',
  },
  ghostty = { ext = '', url = 'https://github.com/ghostty-org/ghostty', label = 'Ghostty' },
  lua = { ext = 'lua', url = 'https://www.lua.org', label = 'Lua Table for testing' },
  slack = { ext = 'txt', url = 'https://slack.com', label = 'Slack' },
  tmux = { ext = 'tmux', url = 'https://github.com/tmux/tmux/wiki', label = 'Tmux' },
}

local style = 'midnight'
local style_name = 'Midnight'

-- local colors = nv.tokyonight.colors
-- local groups = nv.tokyonight.groups
-- local opts = nv.tokyonight.opts
local iter = vim.iter(vim.tbl_keys(extras))

iter:each(function(name)
  local ok, plugin = pcall(require, 'tokyonight.extra.' .. name)
  if not ok then
    return Snacks.notify.error('Failed to load tokyonight.extra.' .. name .. ': ' .. plugin)
  end
  print('Generating extra for ' .. name)
  local content = plugin.generate(require('tokyonight').load(nv.tokyonight.opts))
  local info = extras[name]
  local fname = string
    .format(
      '%s/%s%s/tokyonight%s%s.%s',
      vim.fs.joinpath(vim.fn.stdpath('config'), 'gen', 'tokyonight'),
      name,
      info.subdir and '/' .. info.subdir .. '/' or '',
      info.sep or '_',
      style,
      info.ext
    )
    :gsub('%.$', '') -- remove trailing dot
  nv.util.file.write(fname, content)
  print('Wrote ' .. fname)
end)
