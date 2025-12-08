local dijkstra =
  [[The computing scientist's main challenge is not to get confused by the complexities of his own making.]]

local version = 'NVIM ' .. tostring(vim.version())
---@module "snacks"
---@class snacks.dashboard.Config
return {
  sections = {
    { section = 'header' },
    { icon = ' ', key = 'n', desc = 'New File', action = ':enew | startinsert' },
    {
      icon = ' ',
      key = 'f',
      title = 'Files',
      section = 'recent_files',
      indent = 2,
      action = ':Recent',
    },
    {
      icon = ' ',
      key = '-',
      desc = 'Open Directory',
      action = function()
        ---@type snacks.picker.explorer.Config
        local opts = {
          -- show_preview = function()
          --   return true
          -- end,
        }
        Snacks.picker.explorer(opts)
      end,
    },
    { icon = ' ', key = 'u', desc = 'Update Plugins', action = ':PlugUpdate' },
    { icon = ' ', key = 'm', desc = 'Mason', action = ':Mason' },
    { icon = '󰒲 ', key = 'g', desc = 'Lazygit', action = ':lua Snacks.lazygit()' },
    {
      section = 'terminal',
      cmd = string.format([[ (cowsay "%s"; printf "%s") | lolcat ]], dijkstra, version),
      indent = 10,
      padding = 1,
    },
    -- { desc = version, align = 'center' },
    -- {
    --   function()
    --     local ms = _G.t['VimEnter']
    --     local icon = '⚡ '
    --     return {
    --       align = 'center',
    --       text = {
    --         { icon .. 'Neovim entered in ', hl = 'footer' },
    --         { ms .. 'ms', hl = 'special' },
    --       },
    --     }
    --   end,
    -- },
  },
  formats = {
    -- header = { ('%%s\nNVIM %s'):format(tostring(vim.version())), align = 'center' },
  },
}
