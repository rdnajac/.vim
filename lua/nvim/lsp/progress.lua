local Spinner = function()
  local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
  return spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
end

local callback = function(ev)
  local id, params = ev.data.client_id, ev.data.params
  local value = params.value
  local is_end = value.kind == 'end'
  local title = ([[[%s] %s %s]]):format(
    vim.lsp.get_client_by_id(id).name or 'LSP',
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
end

return {
  callback = callback,
}
