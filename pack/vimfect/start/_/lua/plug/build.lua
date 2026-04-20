return function(ev)
  ---@cast ev {data:vim.event.packchanged.data}
  local data = ev.data
  local name = data.spec.name
  local build = vim.tbl_get(data.spec, 'data', 'build')
  if data.kind == 'delete' or not build then
    return
  end
  if not ev.data.active then
    vim.cmd.packadd(name)
  end
  if type(build) == 'function' then
    build()
    print('Build function called for ' .. name)
  elseif type(build) == 'string' then
    -- trim leading ':' or '<Cmd>' and trailing '<CR>'
    build = vim.trim(build):gsub('^:', ''):gsub('^<[Cc][Mm][Dd]>', ''):gsub('<[Cc][Rr]>$', '')
    vim.cmd(build)
    print('Build string executed for ' .. name)
  end
end
