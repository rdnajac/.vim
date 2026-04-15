local M = {}

M.toggles = require('munchies.toggles')
vim.iter(M.toggles):each(function(k, v)
  local toggle
  if type(v) == 'function' then
    toggle = v()
  elseif type(v) == 'table' then
    toggle = Snacks.toggle.new(v)
  elseif type(v) == 'string' then
    toggle = Snacks.toggle.option(v)
  else
    error(('Invalid toggle type: %s for key: %s'):format(type(v), k))
  end
  if not toggle then
    Snacks.notify.error(('Invalid toggle: %s'):format(k))
  end
  toggle:map(k)
end)

Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)
Snacks.keymap.set({ 'n' }, 'K', vim.lsp.buf.hover, { lsp = {} })
Snacks.keymap.set({ 'n', 'x' }, '<M-CR>', Snacks.debug.run, { ft = 'lua' })
vim
  .iter({
    ['<C-Bslash> '] = Snacks.terminal.focus,
    [']]'] = function() Snacks.words.jump(vim.v.count1) end,
    ['[['] = function() Snacks.words.jump(-vim.v.count1) end,
  })
  :each(function(lhs, rhs) vim.keymap.set({ 'n', 't' }, lhs, rhs) end)

return M
