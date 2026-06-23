local Spinner = function()
  local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
  return spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
end

--- @param ev {data: vim.event.lspprogress.data}
return function(ev)
  local params = ev.data.params ---@type lsp.ProgressParams
  local value = params.value
  local is_end = value.kind == 'end'
  local title = ([[[%s] %s %s]]):format(
    vim.lsp.get_client_by_id(ev.data.client_id).name or 'LSP',
    is_end and '' or Spinner(),
    value.title -- append the original title
  )
  vim.api.nvim_echo({ { value.message or '100% done' } }, false, {
    id = 'lsp.' .. params.token,
    kind = 'progress',
    source = 'nv.lsp',
    title = title,
    status = is_end and 'success' or 'running',
    percent = value.percentage,
    -- verbose = true,
  })
  -- vim.cmd.redrawstatus() -- optional
end
