function Plugin:do_build()
  if not self.build then
    return
  end

  local function notify_build(ok, err)
    local msg = string.format(
      'Build %s for %s%s',
      ok and 'succeeded' or 'failed',
      self.name,
      err and (': ' .. err) or ''
    )
    Snacks.notify(msg, ok and 'info' or 'error')
  end

  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(event)
      if event.data.kind ~= 'update' then
        return
      end

      if vim.is_callable(self.build) then
        local ok, result = pcall(self.build)
        notify_build(ok, not ok and result or nil)
      elseif nv.is_nonempty_string(self.build) then
        local build_str = self.build

        -- Ex command (e.g. ":Make", "<Cmd>make<CR>")
        if build_str:match('^:') or build_str:match('^<Cmd>') then
          build_str = build_str:gsub('^:', '')
          build_str = build_str:gsub('^<Cmd>', '')
          build_str = build_str:gsub('<CR>$', '')
          local ok, err = pcall(vim.cmd, build_str)
          notify_build(ok, not ok and err or nil)
        else
          -- Normalize leading "!" for shell commands
          build_str = build_str:gsub('^!', '')
          local cmd = string.format('cd %s && %s', vim.fn.shellescape(data.spec.dir), build_str)
          local output = vim.fn.system(cmd)
          notify_build(vim.v.shell_error == 0, vim.v.shell_error ~= 0 and output or nil)
        end
      else
        notify_build(false, 'Invalid build type: ' .. type(self.build))
      end
    end,
  })
end
