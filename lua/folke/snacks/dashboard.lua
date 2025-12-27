local short_header = [[
  ---@param ctx {buf:number, ft:string}
  setup = function(ctx)
    vim.b.completion = false
    vim.b.minihipatterns_disable = true
    if vim.fn.exists(':NoMatchParen') == 2 then
      vim.cmd.NoMatchParen()
    end
    vim.cmd.setlocal('foldmethod=manual', 'statuscolumn=', 'conceallevel=0')
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(ctx.buf) then
        -- for json files, keep the filetype as json
        -- for other files, set the syntax to the detected ft
        local opt = ctx.ft == 'json' and 'filetype' or 'syntax'
        vim.bo[ctx.buf][opt] = ctx.ft
      end
    end)
  end,
 ███╗   ██╗██╗   ██╗██╗███╗   ███╗
 ████╗  ██║██║   ██║██║████╗ ████║
 ██╔██╗ ██║██║   ██║██║██╔████╔██║
 ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║
 ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝]]
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
      { icon = ' ', key = 'R', action = ':restart',    desc = 'Restart Neovim' },
      -- stylua: ignore end
    },
  },
  sections = {
    function()
      if vim.o.columns < 56 then
        return {
          pane = 1,
          header = short_header,
          padding = 2,
          align = 'left',
        }
      else
        return { section = 'header' }
      end
    end,
    { section = 'keys' },
    { section = 'terminal', cmd = cmd, indent = 10, padding = 1, height = 12 },
  },
}
