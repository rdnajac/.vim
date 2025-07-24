vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec and ev.data.spec.name
    local build_cmd = M[name] and M[name].build
    print(vim.inspect(ev))
    print(name)
    print(build_cmd)
    async.run(function()
      local output = vim.fn.system(build_cmd)
      local err = vim.v.shell_error ~= 0 and output or nil
      return err, output
    end, function(err, output)
      if err then
        vim.notify('Build error for ' .. name .. ': ' .. err, vim.log.levels.ERROR)
      else
        vim.notify('Build succeeded for ' .. name)
      end
    end)
  end,
})
