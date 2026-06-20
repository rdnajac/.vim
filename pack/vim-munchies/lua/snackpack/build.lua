---@param ev {data:vim.event.packchanged.data}
local function build(ev)
  local data = ev.data
  local name = data.spec.name
  local build = vim.tbl_get(data.spec, 'data', 'build')
  if data.kind ~= 'delete' and build then
    print(('[PackChanged:%s]: building %s'):format(data.kind, name))
    if not data.active then
      vim.cmd.packadd(name)
    end
    if type(build) == 'function' then
      build()
    elseif type(build) == 'string' then -- trim leading ':' or '<Cmd>' and trailing '<CR>'
      vim.cmd(vim.trim(build):gsub('^(%:|<[Cc][Mm][Dd]>)', ''):gsub('<[Cc][Rr]>$', ''))
    end
  end
end

return build
