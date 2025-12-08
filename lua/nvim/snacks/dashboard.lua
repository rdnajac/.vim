local dijkstra = [[
"The computing scientist's main challenge is not to get
confused by the complexities of his own making."
]]
local version = 'NVIM ' .. tostring(vim.version())
local cmd = ([[{ cowsay %s; printf "\n\t%s\n"; } | lolcat ]]):format(dijkstra, version)

---@module "snacks"
---@class snacks.dashboard.Config
return {
  preset = {
    keys = {
      { icon = ' ', key = 'f', title = 'Files', action = ':Recent' },
      { section = 'recent_files', indent = 2 },
      -- stylua: ignore start
      { icon = ' ', key = 'n', action = ':ene | star', desc = 'New File' },
      { icon = ' ', key = '-', action = ':Explorer',   desc = 'Open Directory' },
      { icon = ' ', key = 'u', action = ':PlugUpdate', desc = 'Update Plugins' },
      { icon = ' ', key = 'm', action = ':Mason',      desc = 'Mason' },
      { icon = '󰒲 ', key = 'g', action = ':LazyGit',    desc = 'LazyGit' },
      -- stylua: ignore end
    },
  },
  sections = {
    { section = 'header' },
    { section = 'keys' },
    { section = 'terminal', cmd = cmd, indent = 10, padding = 1, height = 12 },
  },
}
