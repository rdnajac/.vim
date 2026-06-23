vim.loader.enable() -- `https://github.com/neovim/neovim/discussions/36905`

_G.nv = require('nvim')

require('vim._core.ui2').enable({
  msg = { targets = nv.ui.msg.targets },
})

vim.cmd.colorscheme('tokyonight')

require('munchies.snackpack').setup({
  -- dashboard = require('munchies').dashboard,
  explorer = { replace_netrw = true },
  image = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  quickfile = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  words = { enabled = true },
  picker = require('munchies').picker,
})

vim.cmd([[
runtime vimrc
set exrc
nnoremap _ <Cmd>lua Snacks.explorer.reveal()<CR>
nnoremap <C-e> <Cmd>lua Snacks.explorer.open({cwd = Snacks.git.get_root()})<CR>
nnoremap <C-f> <Cmd>lua Snacks.picker()<CR>

nnoremap ZB <Cmd>lua Snacks.bufdelete()<CR>
nnoremap Zb <Cmd>lua Snacks.bufdelete.other()<CR>
nnoremap ,. <Cmd>lua Snacks.scratch.open()<CR>
nnoremap ,, <Cmd>lua Snacks.picker.buffers()<CR>
nnoremap ,/ <Cmd>lua Snacks.picker.grep()<CR>
xnoremap /  <Cmd>lua Snacks.picker.grep_word()<CR>
inoremap <C-x><C-i> <Cmd>lua Snacks.picker.icons({ layout = require('munchies').insert })<CR>
inoremap <C-x><C-z> <Cmd>lua Snacks.picker.registers({ layout = require('munchies').insert })<CR>

nnoremap cd <Cmd>lua Snacks.picker.zoxide()<CR>
nnoremap cd- <Cmd>cd \-<Bar>verbose pwd<CR>
nnoremap cdb <Cmd>cd %:p:h<Bar>verbose pwd<CR>
nnoremap cdg <Cmd>exe 'cd' git#root()<Bar>verbose pwd<CR>

nnoremap cdB <Cmd>exe 'edit' &backupdir<CR>
nnoremap cdc <Cmd>exe 'edit' g:stdpath#config<CR>
nnoremap cdC <Cmd>exe 'edit' g:stdpath#cache<CR>
nnoremap cdd <Cmd>exe 'edit' g:stdpath#data<CR>
nnoremap cds <Cmd>exe 'edit' g:stdpath#state<CR>
nnoremap cdG <Cmd>edit ~/GitHub/<CR>
nnoremap cdN <Cmd>edit ~/GitHub/neovim/<CR>
nnoremap cdp <Cmd>edit ~/.vim/pack/<CR>
nnoremap cdP <Cmd>edit $PACKDIR<CR>
nnoremap cdl <Cmd>edit $PACKDIR/nvim-lspconfig/lua/lspconfig/types/lsp/<CR>
nnoremap cdm <Cmd>edit $PACKDIR/mini.nvim/lua/mini/<CR>
nnoremap cdv <Cmd>edit $VIMRUNTIME/lua/vim<CR>
nnoremap cdV <Cmd>edit $VIMRUNTIME<CR>
nnoremap cd~ <Cmd>edit $HOME<CR>
nnoremap cd. <Cmd>edit ~/.local/share/chezmoi/<CR>

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
nnoremap <leader>gL <Cmd>lua Snacks.picker.git_log_line()<CR>
nnoremap <leader>gl <Cmd>lua Snacks.picker.git_log()<CR>
nnoremap <leader>gs <Cmd>lua Snacks.picker.git_status()<CR>
nnoremap <leader>gS <Cmd>lua Snacks.picker.git_stash()<CR>

nnoremap <leader>G <Cmd>lua Snacks.lazygit()<CR>
nnoremap <leader>H <Cmd>lua Snacks.picker.help()<CR>
]])

vim
  .iter({
    'autocmds',
    'buffers',
    'diagnostics',
    'files',
    'grep',
    'highlights',
    'icons',
    'jumps',
    'keymaps',
    'lines',
    'resume',
    'zoxide',
  })
  :each(function(p)
    local cmd = p:gsub('^%l', string.upper)
    vim.cmd(([[command! %s lua Snacks.picker.%s()]]):format(cmd, p))
    vim.cmd(([[nnoremap <C-F>%s <Cmd>%s<CR>]]):format(p:sub(1, 1), cmd))
  end)

-- stylua: ignore start
vim.keymap.set({ 'n', 't' }, '<C-Bslash>', function() Snacks.terminal.focus() end)
vim.keymap.set({ 'n', 't' }, ']]', function() Snacks.words.jump(vim.v.count1) end)
vim.keymap.set({ 'n', 't' }, '[[', function() Snacks.words.jump(-vim.v.count1) end)
Snacks.keymap.set({ 'n', 'x' }, '<M-CR>', Snacks.debug.run, { ft = 'lua' })
Snacks.keymap.set('n', 'gd', vim.lsp.buf.definition, { lsp = { method = 'textDocument/definition' }, desc = 'Go to Definition' })
Snacks.keymap.set('n', 'K',  vim.lsp.buf.hover, { lsp = { method = 'textDocument/hover' }, desc = 'Lsp Hover' })
