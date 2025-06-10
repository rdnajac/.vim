local M = {}

---@type snacks.dashboard.Config
M.config = {
  sections = {
    { section = 'header' },
    { section = 'keys', padding = 1 },
    { section = 'startup' },
  },
  preset = {
    ---@type snacks.dashboard.Item[]
    keys = {
      { icon = ' ', title = 'Recent Files' },
      { section = 'recent_files', indent = 2, gap = 0 },
      { icon = ' ', key = 'c', desc = 'Config', action = '<leader>fc' },
      -- TODO add config shortcuts
      { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
    },
  },
}

return M
