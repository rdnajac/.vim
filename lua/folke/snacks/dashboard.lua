local header = {
  '███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
  '████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
  '██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
  '██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
  '██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
  '╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
  --1234567890123456789012345678901234567890
}

-- use vim list splice to remove the e and o
-- e starts at 11 and ends at +17
local header = function(cols)
  if cols > 56 then
    return table.concat(header, '\n')
  end
  return vim
    .iter(header)
    :map(function(line)
      -- PERF: use lua?
      local n = vim.fn.strcharpart(line, 0, 10)
      -- if cols < 20 then
      return n .. vim.fn.strcharpart(line, 27) -- nvim
      -- return n .. vim.fn.strcharpart(line, 27, 9) -- nv
    end)
    :join('\n')
end

local dijkstra = [[
"The computing scientist's main challenge is not to get
confused by the complexities of his own making."
]]

-- PERF: wrap in a function to defer requiring vim.version
local cmd = function()
  local version = 'NVIM ' .. tostring(vim.version())
  return ([[{ cowsay %s; printf "\n\t%s\n"; } | lolcat ]]):format(dijkstra, version)
end

---@module "snacks"
---@class snacks.dashboard.Config
return {
  preset = {
    keys = {
      { icon = ' ', key = 'n', desc = 'New File       ', action = ':ene | star' },
      { icon = ' ', key = '-', desc = 'Open Directory ', action = ':Explorer' },
      { icon = ' ', key = 'U', desc = 'Update Plugins ', action = ':PlugUpdate' },
      { icon = ' ', key = 'M', desc = 'Mason          ', action = ':Mason' },
      -- { icon = ' ', key = 'M', desc = 'Mason          ', action = vim.cmd.Mason },
      { icon = '󰒲 ', key = 'G', desc = 'LazyGit        ', action = ':LazyGit' },
      {
        icon = ' ',
        key = 'C',
        des = 'Open Config Dir',
        action = [[:exe 'edit ' . stdpath('config')]],
      },
      -- TODO: better edit shortcuts (that avtually wotk)
      -- checkhealth command
      { icon = ' ', key = 'D', desc = 'Open Data Dir  ', action = ':e stdpath("data")' },
      { icon = ' ', key = 'R', desc = 'Restart Neovim ', action = ':restart' },
    },
  },
  sections = {
    function()
      local cols = vim.o.columns
      -- return { header = header(cols), align = cols <= 40 and 'left' or nil }
      return { header = header(cols) }
    end,
    { section = 'keys' },
    { section = 'terminal', cmd = cmd(), indent = 10, padding = 1, height = 12 },
  },
}
