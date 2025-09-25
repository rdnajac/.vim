vim.api.nvim_create_autocmd('Progress', {
  pattern = { 'term' },
  callback = function(ev)
    print(string.format('event fired: %s', vim.inspect(ev)))
  end,
})
local id = vim.api.nvim_echo(
  { { 'searching...' } },
  true,
  { kind = 'progress', status = 'running', percent = 10, title = 'term' }
)
vim.api.nvim_echo(
  { { 'searching' } },
  true,
  { id = id, kind = 'progress', status = 'running', percent = 50, title = 'term' }
)
vim.api.nvim_echo(
  { { 'done' } },
  true,
  { id = id, kind = 'progress', status = 'success', percent = 100, title = 'term' }
)
