local str = [["The computing scientist's main challenge is not to get confused by the complexities of his own making."]]
local M = {}
---@module "snacks"

---@class snacks.dashboard.Config
M.config = {
  sections = {
    { section = 'header' },
    { section = 'keys' },
    {
      section = 'terminal',
      padding = 1,
      width = 69,
      cmd = 'cowsay ' .. str .. ' | lolcat',
      opts = { win_opts = { border = 'none' } },
      indent = 8,
    },
    { section = 'startup', padding = 1 },
  },
  preset = {
    header = [[
          ██╗      █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗          Z
          ██║     ██╔══██╗╚══███╔╝╚██╗ ██╔╝██║   ██║██║████╗ ████║      Z    
          ██║     ███████║  ███╔╝  ╚████╔╝ ██║   ██║██║██╔████╔██║   z       
          ██║     ██╔══██║ ███╔╝    ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║ z         
          ███████╗██║  ██║███████╗   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║           
          ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝           
    ]],
    keys = {
      { icon = ' ', title = 'Recent Files' },
      -- TODO: add resture session button/function/command
      -- { section = 'recent_files', indent = 2, gap = 0 },
      { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
      { icon = ' ', key = 'h', desc = 'Health', action = ':LazyHealth' },
      { icon = ' ', key = 'g', desc = 'Lazygit', action = ':Lazygit' },
      { icon = '󱌣 ', key = 'm', desc = 'Mason', action = ':Mason' },
      { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
    },
  },
  formats = {
    key = function(item)
      local sep = LazyVim.config.separators.section.rounded
      return {
        { sep.right, hl = 'special' },
        { item.key, hl = 'key' },
        { sep.left, hl = 'special' },
      }
    end,
    file = function(item, ctx)
      local fname = vim.fn.fnamemodify(item.file, ':~')
      fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
      if #fname > ctx.width then
        local dir = vim.fn.fnamemodify(fname, ':h')
        local file = vim.fn.fnamemodify(fname, ':t')
        if dir and file then
          file = file:sub(-(ctx.width - #dir - 2))
          fname = dir .. '/…' .. file
        end
      end
      local dir, file = fname:match('^(.*)/(.+)$')
      return dir and { { dir .. '/', hl = 'dir' }, { file, hl = 'file' } } or { { fname, hl = 'file' } }
    end,
  },
}

return M
