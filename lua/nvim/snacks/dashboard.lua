local dijkstra =
  [["The computing scientist's main challenge is not to get confused by the complexities of his own making."]]

---@module "snacks"
---@class snacks.dashboard.Config
return {
  sections = {
    { section = 'header' },
    {
      pane = 2,
      icon = ' ',
      title = 'Files',
      section = 'recent_files',
      indent = 2,
      key = 'f',
      action = ':Recent',
    },
    { icon = ' ', key = 'f', desc = 'Find File', action = ':Files' },
    { icon = ' ', key = 'n', desc = 'New File', action = ':enew | startinsert' },
    -- { icon = ' ', key = '-', desc = 'Open Directory', action = ':e $PWD' },
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
    {
      pane = 2,
      icon = '',
      title = 'Plugins',
      indent = 2,
      key = 'p',
      action = ':PlugStatus',
      { icon = ' ', key = 'u', desc = 'Update', action = ':PlugUpdate', indent = 2 },
      { icon = ' ', key = 'm', desc = 'Mason', action = ':Mason', indent = 2 },
      { icon = '󰒲 ', key = 'g', desc = 'Lazygit', action = ':lua Snacks.lazygit()', indent = 2 },
    },
    { section = 'terminal', cmd = 'cowsay ' .. dijkstra, indent = 10, padding = 1 },
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
    -- header = { '%s' .. '\nNVIM ' .. tostring(vim.version()), align = 'center' },
    header = { ('%%s\nNVIM %s'):format(tostring(vim.version())), align = 'center' },
  },
  -- wo = { winbar = '', winhighlight = { 'WinBar:NONE' } },
}
