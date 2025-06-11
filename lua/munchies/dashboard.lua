local str = [["The computing scientist's main challenge is not to get confused by the complexities of his own making."]]

-- stylua: ignore start
local short = function() return vim.o.lines < 24 end
local narrow = function() return vim.o.columns < 48 end
local wide = function() return vim.o.columns >= 128 end
local in_git_repo = function() return Snacks.git.get_root() ~= nil end
local setseed = function() math.randomseed(os.time()) end
-- stylua: ignore end

local headers = {
  'lazy',
  'nvim',
  'ryan',
  '\\?\\?\\?\\?\\?',
  'wow!',
  'quit',
  'cbmf',
  'cmd',
}

local random_unown = function()
  setseed()
  return 'unown ' .. headers[math.random(#strings)]
end

local unown = function()
  local head = wide() and 'neovim' or 'vim'
  return 'unown ' .. head
end

local cowsay = function()
  local cmd = ''
  setseed()
  if math.random(1, 2) == 1 then
    cmd = 'cowsay ' .. str .. ' | lolcat'
  else
    -- Add a timestamp to make each command unique
    cmd = 'fortune -n 69 -s | cowsay | lolcat # ' .. os.time()
  end
  return cmd
end

-- stylua: ignore
local M = {
  preset = {
    keys = {
      { icon = ' ', key = 'f', title = 'Files',   action = function() Snacks.picker.recent() end },
      { icon = ' ', key = 'g', title = 'Lazygit', action = function() Snacks.lazygit() end, enabled = function() return not wide() and in_git_repo() end },
      { icon = " ", key = "s", desc = 'Session',  action = function() require("persistence").load({ last = true }) end },
      { icon = ' ', key = 'c', desc = 'Config',   action = function() Snacks.picker.files({cwd = vim.fn.expand('$DOTDIR')}) end },
      { icon = '󰄻 ', key = 'z', desc = 'Zoxide',   action = function() Snacks.picker.zoxide() end },
      { icon = '󰒲 ', key = 'l', desc = 'Lazy',     action = ':Lazy' },
      { icon = ' ', key = 'x', desc = 'Extras',   action = ':LazyExtras' },
      { icon = ' ', key = 'h', desc = 'Health',   action = ':checkhealth' },
      { icon = '󱌣 ', key = 'm', desc = 'Mason',    action = ':Mason' },
      { icon = ' ', key = 'q', desc = 'Quit',     action = ':qa' },
    }
  },
  formats = { key = function(item) return {{'[ ', hl = 'special' }, {item.key, hl = 'key'}, {' ]', hl = 'special'}} end },
  sections = {
    {
      section = 'terminal',
      padding = 1,
      width = 69,
      cmd = 'unown nvim',
      enabled = function() return not short() and not narrow() and not wide() end,
    },
    {
      section = 'terminal',
      padding = 2,
      indent = math.floor((vim.o.columns - 102) / 2 ) - 29,
      width = 120,
      cmd = 'unown neovim',
      enabled = function() return not short() and not narrow() and wide() end,
    },
    {
      pane = 1, enabled = function() return wide() end,
      { icon = ' ', title = 'Files', key = 'f', action = function() Snacks.picker.smart() end },
    },
    {
      pane = 1, enabled = function() return wide() and in_git_repo() end,
      { icon = ' ', title = 'Lazygit', key = 'g', action = function() Snacks.lazygit() end },
      {
        section = 'terminal',
        cmd = 'git status --short --branch --renames',
        padding = 1,
        indent = 1,
      },
    },
    {
      section = 'keys', pane = 1,
      enabled = function() return not wide() end,
    },
    {
      section = 'terminal',
      indent = 11,
      height = 10,
      cmd = 'echo ',
      -- cmd = cowsay(),
      -- enabled = function() return not narrow() end,
      enabled = false,
      padding = 2,
    },
    { 
      padding = 11,
      pane = 2,
      enabled = wide(),
    },
    {
      section = 'keys', pane = 2,
      gap = in_git_repo() and 1 or 0,
      enabled = function() return wide() end,
    },
    { padding = 1 },
    { section = 'startup', enabled = function() return not wide() end },
    -- { section = 'startup', indent = math.floor((vim.o.columns - 50) / 2) },
  },
}

return M
