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

-- stylua: ignore
local _keys = {
  { ' ', 'New File',       'n', ':ene | star' },
  { ' ', 'Update Plugins', 'U', ':PlugUpdate' },
  { ' ', 'Mason',          'M', ':Mason' },
  { '󰒲 ', 'LazyGit',        'G', ':LazyGit' },
  { ' ', 'News',           'N', ':News' },
  { ' ', 'Health',         'H', ':packloadall|checkhealth' },
  { '󱥰 ', 'Edit Dashboard', 'D', edit_dashboard },
  { ' ', 'Restart',        'R', ':restart' },
}

local render_key = function(t)
  local icon, desc, key, action = unpack(t)
  return { icon = icon, desc = desc, key = key, action = action, hidden = true }
end

local keys = vim.tbl_map(render_key, _keys)

local function get_keys()
  local lines = {}
  for _, item in ipairs(keys) do
    lines[#lines + 1] = string.format('%s  %-44s %s', item.icon, item.desc, item.key)
  end
  return table.concat(lines, '\n')
end

local welcome = function()
  local version = 'NVIM ' .. tostring(vim.version())

  return string.format(
    "(printf '%%s\\n\\n' %s; printf '%%s\\n\\n' %s; cowsay %s; printf '\\n\\t%%s\\n' %s) | lolcat",
    vim.fn.shellescape(header),
    vim.fn.shellescape(get_keys()),
    vim.fn.shellescape(dijkstra),
    vim.fn.shellescape(version)
  )
end

---@type snacks.dashboard.Config
return {
  sections = {
    {
      section = 'terminal',
      cmd = welcome(),
      height = 42,
    },
    { keys },
    -- { section = 'header' },
  },
}
