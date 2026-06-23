local M = {}

-- if type(build) == 'function' then build()
-- elseif type(build) == 'string' then -- trim leading ':' or '<Cmd>' and trailing '<CR>'
-- vim.cmd(vim.trim(build):gsub('^(%:|<[Cc][Mm][Dd]>)', ''):gsub('<[Cc][Rr]>$', ''))
--- @param ev {data:vim.event.packchanged.data}
M.build = function(ev)
  local data = ev.data
  if data.kind == 'delete' then
    return
  end
  local name = data.spec.name
  if name == 'blink.cmp' then
    Plug('Saghen/blink.lib')
    if not data.active then
      vim.cmd.packadd(name)
    end
    ---@module "blink.lib"
    require('blink.cmp').build():schedule()
  end
end

return M.build
