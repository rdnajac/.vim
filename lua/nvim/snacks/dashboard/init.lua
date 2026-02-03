---@module "snacks"
---@class snacks.dashboard.Config
return {
  preset = {
    keys = {
      { icon = ' ', key = 'n', desc = 'New File       ', action = ':ene | star' },
      { icon = ' ', key = '-', desc = 'Open Directory ', action = ':Explorer' },
      { icon = ' ', key = 'U', desc = 'Update Plugins ', action = ':PlugUpdate' },
      { icon = ' ', key = 'M', desc = 'Mason          ', action = ':Mason' },
      { icon = '󰒲 ', key = 'G', desc = 'LazyGit        ', action = ':LazyGit' },
      { icon = ' ', key = 'H', desc = 'Neovim Health  ', action = ':checkhealth' },
      { icon = ' ', key = 'R', desc = 'Restart Neovim ', action = ':restart' },
    },
  },
  sections = {
    function() return { header = require('nvim.snacks.dashboard.header')(vim.o.columns) } end,
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
