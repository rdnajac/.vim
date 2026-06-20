" see `:h dir`
setlocal nonumber
lua vim.keymap.set('n', { 'h', '<Left>'  }, '<Plug>(nvim-dir-up)',   { buf = 0 })
lua vim.keymap.set('n', { 'l', '<Right>' }, '<Plug>(nvim-dir-open)', { buf = 0 })
nnoremap <buffer> t o<Esc>:r !find '<C-R>=substitute(getline(line(".")-1),"\\n","","g")<CR>' -maxdepth 1 -print0 \| xargs -0 ls -Fd<CR>:silent! keeppatterns %s/\/\//\//g<CR>:silent! keeppatterns %s/[^a-zA-Z0-9\/]$//g<CR>:silent! keeppatterns g/^$/d _<CR>"_dd<CR>
nnoremap <buffer> o <Cmd>lua vim.ui.input({prompt='new file: '}, function(input) vim.cmd.edit(vim.fs.joinpath(vim.fn.expand('%'),input)) end)<CR>
nnoremap <buffer> D <Cmd>lua vim.lsp.buf.code_action({filter=function(action) return action.command and action.command.command == 'delete' end, apply=true})<CR>
nnoremap <buffer> C <Cmd>lua vim.lsp.buf.code_action({filter=function(action) return action.command and action.command.command == 'rename' end, apply=true})<CR>
lua vim.schedule(nv.fs.thumbnails.render)
