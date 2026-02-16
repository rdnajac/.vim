local M = setmetatable({}, {
  __call = function(M, ...) return M.build(...) end,
})

M.build = function(event)
  local kind = event.data.kind ---@type "install"|"update"|"delete"
  if kind == 'delete' then
    return
  end
  local spec = event.data.spec ---@type vim.pack.Spec
  local build = spec.data and spec.data.build
  if type(build) == 'function' then
    if not event.data.active then
      vim.cmd.packadd(spec.name)
    end
    build()
    print('Build function executed for ' .. spec.name)
  elseif type(build) == 'string' then
    -- trim leading ':' or '<Cmd>' and trailing '<CR>'
    build = build:gsub('^:*', ''):gsub('^<[Cc][Mm][Dd]>', ''):gsub('<[Cc][Rr]>$', '')
    vim.cmd(build)
    print('Build string executed for ' .. spec.name)
  end
end

return M
