local me = debug.getinfo(1, 'S').source:sub(2)
local NEOVIM = {
  '███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
  '████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
  '██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
  '██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
  '██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
  '╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
  --1234567890123456789012345678901234567890
}

local keys = {
  { icon = ' ', key = 'n', desc = 'New File', action = ':ene | star' },
  { icon = ' ', key = '-', desc = 'Browse Directory', action = ':Explorer' },
  { icon = ' ', key = 'U', desc = 'Update', action = ':Update' },
  { icon = ' ', key = 'M', desc = 'Mason', action = ':Mason' },
  { icon = '󰒲 ', key = 'G', desc = 'LazyGit', action = ':LazyGit' },
  { icon = ' ', key = 'N', desc = 'News', action = ':News' },
  { icon = ' ', key = 'H', desc = 'Health', action = ':Health' },
  { icon = '󱥰 ', key = 'D', desc = 'Edit Dashboard', action = ':e ' .. me },
  { icon = ' ', key = 'R', desc = 'Restart', action = ':Restart' },
}

-- use vim list splice to remove the e and o
-- e starts at 11 and ends at +17
local header = function(cols)
  if cols > 56 then
    return table.concat(NEOVIM, '\n')
  end
  return vim
    .iter(NEOVIM)
    :map(function(line)
      -- PERF: use lua?
      local n = vim.fn.strcharpart(line, 0, 10)
      -- if cols < 20 then
      return n .. vim.fn.strcharpart(line, 27) -- nvim
      -- return n .. vim.fn.strcharpart(line, 27, 9) -- nv
    end)
    :join('\n')
end

---@type snacks.dashboard.Config
return {
  preset = { keys = keys },
  sections = {
    function() return { header = header(vim.o.columns) } end,
    { section = 'keys' },
    { -- requires cowsay and lolcat
      section = 'terminal',
      cmd = require('nvim.snacks.dashboard.welcome')(),
      indent = 10,
      padding = 1,
      height = 12,
    },
  },
}
-- local me = debug.getinfo(1, 'S').source:sub(2)
