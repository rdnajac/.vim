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

-- Snacks.config.style('lazygit', { height = 0, width = 0 })
-- vim.cmd('hi! SnacksDashboardFile guifg=#2AC3DE gui=bold')

vim.cmd([[
nnoremap ZB <Cmd>lua Snacks.bufdelete()<CR>
nnoremap Zb <Cmd>lua Snacks.bufdelete.other()<CR>
nnoremap ,. <Cmd>lua Snacks.scratch.open()<CR>
nnoremap ,, <Cmd>lua Snacks.picker.buffers()<CR>
nnoremap ,/ <Cmd>lua Snacks.picker.grep()<CR>
xnoremap /  <Cmd>lua Snacks.picker.grep_word()<CR>
inoremap <C-x><C-i> <Cmd>lua Snacks.picker.icons({ layout = require('munchies').insert })<CR>
inoremap <C-x><C-z> <Cmd>lua Snacks.picker.registers({ layout = require('munchies').insert })<CR>

nnoremap glc <Cmd>lua Snacks.picker.lsp_config()<CR>
nnoremap gls <Cmd>lua Snacks.picker.lsp_symbols()<CR>
nnoremap glS <Cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>
nnoremap gli <Cmd>lua Snacks.picker.lsp_incoming_calls()<CR>
nnoremap glo <Cmd>lua Snacks.picker.lsp_outgoing_calls()<CR>
nnoremap gld <Cmd>lua Snacks.picker.lsp_definitions()<CR>
nnoremap glD <Cmd>lua Snacks.picker.lsp_declarations()<CR>
nnoremap glR <Cmd>lua Snacks.picker.lsp_references()<CR>
nnoremap glI <Cmd>lua Snacks.picker.lsp_implementations()<CR>
nnoremap glT <Cmd>lua Snacks.picker.lsp_type_definitions()<CR>
nnoremap glW <Cmd>=vim.lsp.buf.list_workspace_folders()<CR>
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
