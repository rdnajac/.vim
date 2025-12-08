local function nnoremap(lhs, rhs, opts)
  vim.keymap.set('n', lhs, rhs, opts or {})
end

-- nnoremap('zS', vim.showpos)
nnoremap('<leader>ui', vim.show_pos, { desc = 'vim.show_pos()' })
nnoremap('<leader>uI', function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input('I')
end, { desc = 'Inspect Tree' })

nnoremap('yu', nv.debug.print, { desc = 'Debug print <cword>' })

-- shortcuts with <Bslash> {{{
local shortcuts = {
  n = 'nvim/init',
  s = 'nvim/snacks',
  c = 'nvim/config',
  p = 'nvim/util/plug',
  P = 'nvim/plugins/init',
  m = 'nvim/plugins/mini',
  u = 'nvim/util/init',
  k = 'nvim/config/keymaps',
}

for key, mod in pairs(shortcuts) do
  nnoremap('<Bslash>' .. key, function()
    vim.fn['edit#luamod'](mod)
  end, { desc = 'Edit ' .. mod })
end
-- }}}
-- from LazyVim {{{
local diagnostic_goto = function(next)
  return function()
    vim.diagnostic.jump({
      count = (next and 1 or -1) * vim.v.count1,
      -- severity = severity and vim.diagnostic.severity[severity] or nil,
      float = true,
    })
  end
end

nnoremap(']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
nnoremap('[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })

nnoremap('<leader>xl', function()
  local success, err =
    pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.Cmd.lclose or vim.Cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = 'Location List' })

nnoremap('<leader>xq', function()
  local success, err =
    pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.Cmd.cclose or vim.Cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = 'Quickfix List' })
-- }}}
-- Snacks.util.on_key {{{
Snacks.util.on_key('<Esc>', function()
  vim.cmd.nohlsearch()
  if package.loaded['sidekick'] then
    require('sidekick').clear()
  end
end)

Snacks.util.on_key('<C-Space>', function()
  if package.loaded['sidekick'] then
    require('sidekick').clear()
  end
end)
-- }}}
-- vim: fdm=marker fdl=0
