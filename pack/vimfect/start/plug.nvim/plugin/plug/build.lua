-- TODO: this has been fixed in a recent update. revise:
-- also sometimes breaks on initial install
vim.api.nvim_create_autocmd({ 'PackChanged' }, {
  callback = function(event)
    local kind = event.data.kind ---@type "install"|"update"|"delete"
    if kind ~= 'update' then
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
  end,
})
