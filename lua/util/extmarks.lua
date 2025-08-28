vim.keymap.set('n', '<leader>ux', function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  line = line - 1 -- Lua indexing

  -- Get all namespaces
  local extmarks = {}
  for ns_name, ns_id in pairs(vim.api.nvim_get_namespaces()) do
    local marks = vim.api.nvim_buf_get_extmarks(
      0,
      ns_id,
      { line, col },
      { line, col },
      { details = true }
    )
    if #marks > 0 then
      extmarks[ns_name] = marks
    end
  end

  if vim.tbl_isempty(extmarks) then
    print('No extmarks at cursor')
  else
    print(vim.inspect(extmarks))
  end
end, { desc = 'Check extmarks at cursor' })

