local M = {}
local header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]]

local NEOVIM = {
  '███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
  '████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
  '██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
  '██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
  '██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
  '╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
  --1234567890123456789012345678901234567890
}
-- assert(header == table.concat(NEOVIM, '\n'))

M.header = function(cols)
  return vim.o.cols > 56 and table.concat(NEOVIM, '\n')
    or vim
      .iter(NEOVIM)
      :map(function(line)
        local n = vim.fn.strcharpart(line, 0, 10)
        return n .. vim.fn.strcharpart(line, cols < 20 and 27 or 9) -- nv(im)
      end)
      :join('\n')
end

M.opts = {
  sections = {
    { section = 'header' },
    { icon = '󰱼 ', title = 'Files', { section = 'recent_files', indent = 2 } },
    { icon = ' ', desc = 'Health ', key = 'H', action = ':checkhealth' },
    { icon = '󰒲 ', desc = 'LazyGit', key = 'G', action = ':lua Snacks.lazygit()' },
    { icon = ' ', desc = 'Mason  ', key = 'M', action = ':Mason' },
    { icon = ' ', desc = 'News   ', key = 'N', action = ':News' },
    { icon = ' ', desc = 'Update ', key = 'U', action = ':lua vim.pack.update()' },
    {
      section = 'terminal',
      cmd = ('cowsay "%s"|sed "s/^/        /"'):format(
        "The computing scientist's main challenge is not to get confused by the complexities of his own making"
      ),
      padding = 1,
    },
    { footer = tostring(vim.version()) },
  },
}

--- default `Snacks.dashboard` errors because it unconditionally requires `lazy.nvim`
function M.preload_lazy_stats()
  package.preload['lazy.stats'] = function()
    local startuptime = ((_G.T2 or vim.uv.hrtime()) - T1) / 1e6
    return {
      stats = function()
        local count = #vim.fn.readdir(vim.env.PACKDIR)
        -- local loaded = #vim.tbl_filter(function(p) return not p.active end, vim.pack.get())
        local loaded = _G.setup_count or 0
        return { count = count, loaded = loaded, startuptime = startuptime }
      end,
    }
  end
end

return M
