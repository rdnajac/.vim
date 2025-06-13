local str = [["The computing scientist's main challenge is not to get confused by the complexities of his own making."]]
local M = {}

---@type snacks.dashboard.Config
M.config = {
  sections = {
    { section = 'header' },
    { section = 'keys', padding = 1 },
    -- {
    --   section = 'terminal',
    --   padding = 1,
    --   width = 69,
    --   cmd = 'cowsay ' .. str .. ' | lolcat',
    -- },
    { section = 'startup' },
  },
  preset = {
    keys = {
      { icon = ' ', title = 'Recent Files' },
      { section = 'recent_files', indent = 2, gap = 0 },
      { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
      { icon = ' ', key = 'h', desc = 'Health', action = ':LazyHealth' },
      { icon = ' ', key = 'g', desc = 'Lazygit', action = ':Lazygit' },
      { icon = '󱌣 ', key = 'm', desc = 'Mason', action = ':Mason' },
      { icon = ' ', key = 'c', desc = 'Config', action = '<leader>fc' },
      { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
    },
  },
  formats = {
    key = function(item)
      return { { '[ ', hl = 'special' }, { item.key, hl = 'key' }, { ' ]', hl = 'special' } }
    end,
  },
}

return M
