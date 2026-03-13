local header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]]
local function edit_dashboard() vim.cmd('e ' .. debug.getinfo(1, 'S').source:sub(2)) end

local dijkstra = [[
The computing scientist's main challenge is not to 
get confused by the complexities of his own making.
]]

local hide_keys = false

local keys = {
  { hidden = hide_keys, icon = ' ', key = 'n', desc = 'New File', action = ':ene | star' },
  { hidden = hide_keys, icon = ' ', key = 'U', desc = 'Update Plugins', action = ':PlugUpdate' },
  { hidden = hide_keys, icon = ' ', key = 'M', desc = 'Mason', action = ':Mason' },
  { hidden = hide_keys, icon = '󰒲 ', key = 'G', desc = 'LazyGit', action = ':LazyGit' },
  { hidden = hide_keys, icon = ' ', key = 'N', desc = 'News', action = ':News' },
  { hidden = hide_keys, icon = ' ', key = 'H', desc = 'Health', action = ':packloadall|checkhealth' },
  { hidden = hide_keys, icon = '󱥰 ', key = 'D', desc = 'Edit Dashboard', action = edit_dashboard },
  { hidden = hide_keys, icon = ' ', key = 'R', desc = 'Restart', action = ':restart' },
}

local function get_keys()
  local lines = {}
  for _, item in ipairs(keys) do
    lines[#lines + 1] = ('%s[%s] %s'):format(item.icon, item.key, item.desc)
  end
  return table.concat(lines, '\n')
end

local welcome = function()
  local version = 'NVIM ' .. tostring(vim.version())
  local out = string.format(
    -- 'printf "%s"\n; cowsay "%s"; printf "\n\t%s\n"',
    'cowsay "%s"; printf "\n\t%s\n"',
    -- header .. '\n' .. get_keys(),
    dijkstra,
    version
  )
  -- if vim.fn.executable('lolcat') == 1 then
  --   out = ('{ %s; } | lolcat'):format(out)
  -- end
  return out
end

---@type snacks.dashboard.Config
return {
  sections = {
    { section = 'header' },
    { keys },
    {
      section = 'terminal',
      cmd = welcome(),
      indent = 10,
      padding = 1,
      height = 12,
    },
  },
}
