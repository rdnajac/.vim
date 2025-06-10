
  -- Snacks terminal flags
  flag({
    name = 'snacks_terminal_auto_insert',
    mapping = '<leader>ti',
    desc = 'Toggle Terminal Auto Insert',
    label = 'Auto Insert (on buffer enter)',
  })

  flag({
    name = 'snacks_terminal_start_insert',
    mapping = '<leader>tI',
    desc = 'Toggle Terminal Start Insert',
    label = 'Start Insert (on terminal open)',
  })
end

local function snacks_terminal_toggle_or_open()
  local var = Snacks.util.var

  local opts = {
    auto_insert = var(0, 'snacks_terminal_auto_insert', 0) == 1,
    start_insert = var(0, 'snacks_terminal_start_insert', 0) == 1,
  }

  local term, created = Snacks.terminal.get(nil, opts)
  if not created and term ~= nil then
    term:toggle()
  end
end

