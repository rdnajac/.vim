vim.api.nvim_create_user_command('Hardcopy', function()
  local cmd = {
    'vim',
    -- '--not-a-term',
    '-Nu',
    'NONE',
    '-es',
    vim.api.nvim_buf_get_name(0),
    '-c',
    'hardcopy | qa!',
  }
  -- local obj = vim.system(cmd):wait()
  -- dd(obj)
  Snacks.terminal.open(cmd)
end, {})
