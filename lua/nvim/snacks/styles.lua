---@module "snacks"
---@type table<string, snacks.win.Config>
return {
  dashboard = { wo = { winhighlight = 'WinBar:NONE' } },
  lazygit = { height = 0, width = 0 },
  terminal = { wo = { winbar = '', winhighlight = 'Normal:Character' } },
  notification_history = {
    wo = { number = false, winhighlight = 'WinBar:Chromatophore' },
    position = 'bottom',
    width = 100,
    height = 0.4,
  },
}
