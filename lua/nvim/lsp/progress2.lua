vim.api.nvim_create_autocmd('LspProgress', {
  group = vim.api.nvim_create_augroup('LspProgressGroup', { clear = true }),
  callback = function(ev)
    local value = ev.data.params.value
    local msg = string.format(
      '%s: %s [%s%%]',
      value.title or 'LSP',
      value.message or '',
      value.percentage or 100
    )
    local opts =
      { kind = 'progress', title = value.title, percent = value.percentage, status = 'running' }
    if value.kind == 'begin' then
      vim.api.nvim_echo({ { msg, 'MoreMsg' } }, true, opts)
    elseif value.kind == 'report' then
      vim.api.nvim_echo({ { msg, 'MoreMsg' } }, true, opts)
    -- elseif value.kind == 'end' then
      -- opts.percent = 100
      -- opts.status = 'success'
      -- vim.api.nvim_echo({ { msg, 'MoreMsg' } }, true, opts)
      -- { { msg, 'OkMsg' } },
      -- { kind = 'progress', title = value.title, percent = 100, status = 'success' }
    end
  end,
})
