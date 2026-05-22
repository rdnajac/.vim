if vim.g.loaded_munchies ~= nil then
  return
end
vim.g.loaded_munchies = 1

require('snacks').setup({
  -- dashboard = { enabled = true },
  explorer = { enabled = true },
  image = { enabled = true },
  indent = { enabled = true }, -- TODO: native intent guides
  input = { enabled = true },
  -- quickfile = { enabled = true },
  picker = require('munchies').picker,
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = require('munchies').statuscolumn,
  words = { enabled = true },
})

-- vim.schedule(function() Snacks.config.style('lazygit', { height = 0, width = 0 }) end)
-- vim.cmd([[ hi! SnacksDashboardFile guifg=#2AC3DE gui=bold ]])

vim.cmd([[
nnoremap ZB <Cmd>lua Snacks.bufdelete()<CR>
nnoremap Zb <Cmd>lua Snacks.bufdelete.other()<CR>
nnoremap ,. <Cmd>lua Snacks.scratch.open()<CR>
nnoremap ,, <Cmd>lua Snacks.picker.buffers()<CR>
nnoremap ,/ <Cmd>lua Snacks.picker.grep()<CR>
xnoremap /  <Cmd>lua Snacks.picker.grep_word()<CR>
inoremap <C-x><C-i> <Cmd>lua Snacks.picker.icons({ layout = require('munchies').insert })<CR>
inoremap <C-x><C-z> <Cmd>lua Snacks.picker.registers({ layout = require('munchies').insert })<CR>
]])

vim.schedule(function()
  Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)
  Snacks.keymap.set({ 'n' }, 'K', vim.lsp.buf.hover, { lsp = {} })
  Snacks.keymap.set({ 'n', 'x' }, '<M-CR>', Snacks.debug.run, { ft = 'lua' })
  Snacks.keymap.set({ 'x' }, '<M-CR>', Snacks.debug.run, { ft = 'markdown' })
  -- normal and terminal mode keymaps
  for lhs, rhs in pairs({
    ['<C-Bslash>'] = function() Snacks.terminal.focus() end,
    [']]'] = function() Snacks.words.jump(vim.v.count1) end,
    ['[['] = function() Snacks.words.jump(-vim.v.count1) end,
  }) do
    vim.keymap.set({ 'n', 't' }, lhs, rhs)
  end
  -- stylua: ignore
  vim.iter(require('nvim.keys.toggles')):each(function(k, v)
    if type(v) == 'table' then Snacks.toggle.new(v):map(k) end
    if type(v) == 'string' then Snacks.toggle.option(v):map(k) end
    if type(v) == 'function' then v():map(k) end
  end)
end)
