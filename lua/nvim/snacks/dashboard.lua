local header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝

]]

local cowsay = vim.system({ 'cowsay-dash' }):wait().stdout

---@module "snacks"
---@class snacks.dashboard.Config
return {
  preset = { header = header .. cowsay },
  sections = {
    { section = 'header', indent = 4 },
    { padding = 1 },
  },
  formats = {
    -- header = { '%s', align = 'center', hl = 'Chromatophore' },
    header = { '%s', hl = 'Chromatophore' },
    key = function(item)
      return { item.key, hl = 'Chromatophore' }
    end,
  },
  -- wo = { winbar = '', winhighlight = { 'WinBar:NONE' } },
}
