if vim.g.loaded_munchies == nil then
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
  vim.g.loaded_munchies = 1
end

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

nnoremap <leader>gb <Cmd>lua Snacks.picker.git_branches()<CR>
nnoremap <leader>gd <Cmd>lua Snacks.picker.git_diff()<CR>
nnoremap <leader>gf <Cmd>lua Snacks.picker.git_log_file()<CR>
nnoremap <leader>gg <Cmd>lua Snacks.lazygit()<CR>
nnoremap <leader>gL <Cmd>lua Snacks.picker.git_log_line()<CR>
nnoremap <leader>gl <Cmd>lua Snacks.picker.git_log()<CR>
nnoremap <leader>gs <Cmd>lua Snacks.picker.git_status()<CR>
nnoremap <leader>gS <Cmd>lua Snacks.picker.git_stash()<CR>

nnoremap <C-S-F> <Cmd>lua Snacks.picker()<CR>
]])

 -- TODO: also see `vim.on_key`
Snacks.util.on_key('<Esc>', function() vim.cmd.nohlsearch() end)

Snacks.keymap.set({ 'n', 'x' }, '<M-CR>', function()
  vim.print(
    table.concat(
      { '```lua,', ('Snacks.debug.run("%s")'):format(vim.api.nvim_buf_get_name(0)), '```' },
      '\n'
    )
  )
  Snacks.debug.run()
end, { ft = 'lua' })

-- TODO: normal mode map to select and run code block, then run it if lua
Snacks.keymap.set('x', '<M-CR>', Snacks.debug.run, { ft = 'markdown', desc = 'Run lua code block' })

-- normal and terminal mode keymaps
vim.keymap.set({ 'n', 't' }, '<C-Bslash>', function() Snacks.terminal.focus() end)
vim.keymap.set({ 'n', 't' }, ']]', function() Snacks.words.jump(vim.v.count1) end)
vim.keymap.set({ 'n', 't' }, '[[', function() Snacks.words.jump(-vim.v.count1) end)

vim.schedule(function()
  vim.iter({ 'autocmds', 'buffers', 'files', 'help', 'recent', 'grep', 'zoxide' }):each(function(p)
    vim.cmd(([[command! %s lua Snacks.picker.%s()]]):format(require('nvim.util').capitalize(p), p))
    vim.keymap.set('n', '<C-F>' .. p:sub(1, 1), Snacks.picker[p], { desc = 'Snacks.picker.' .. p })
  end)
end)
