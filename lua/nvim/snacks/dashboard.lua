local me = debug.getinfo(1, 'S').source:sub(2)
-- stylua: ignore
local keys = {
  { icon = ' ', key = '-', desc = 'Open Directory', action = function() Snacks.explorer() end },
  { icon = ' ', key = 'n', desc = 'New File',       action = ':ene | star' },
  { icon = ' ', key = 'U', desc = 'Update Plugins', action = ':PlugUpdate' },
  { icon = ' ', key = 'M', desc = 'Mason',          action = ':Mason' },
  { icon = '󰒲 ', key = 'G', desc = 'LazyGit',        action = ':LazyGit' },
  { icon = ' ', key = 'N', desc = 'News',           action = ':News' },
  { icon = ' ', key = 'H', desc = 'Health',         action = ':Health' },
  { icon = '󱥰 ', key = 'D', desc = 'Edit Dashboard', action = ':e ' .. me },
  { icon = ' ', key = 'R', desc = 'Restart',        action = ':Restart' },
}

---@type snacks.dashboard.Config
return {
  preset = { keys = keys },
  sections = {
    { section = 'header' },
    { section = 'keys' },
    {
      section = 'terminal',
      cmd = require('nvim.snacks.dashboard.welcome')(),
      indent = 10,
      padding = 1,
      height = 12,
    },
  },
}
