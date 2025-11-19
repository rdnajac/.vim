nnoremap <buffer> <Left> <Plug>(dirvish_up)
nnoremap <buffer> <Right> <Cmd>call dirvish#open("edit", 0)<CR>
nnoremap <buffer> h <Plug>(dirvish_up)
nnoremap <buffer> l <Cmd>call dirvish#open("edit", 0)<CR>
nnoremap <buffer> o <Cmd>lua nv.fn.new()<CR>
nnoremap <buffer> D <Cmd>lua vim.lsp.buf.code_action({filter=function(action) return action.command and action.command.command == 'delete' end, apply=true})<CR>
nnoremap <buffer> C <Cmd>lua vim.lsp.buf.code_action({filter=function(action) return action.command and action.command.command == 'rename' end, apply=true})<CR>
nnoremap <buffer> t o<Esc>:r !find '<C-R>=substitute(getline(line(".")-1),"\\n","","g")<CR>' -maxdepth 1 -print0 \| xargs -0 ls -Fd<CR>:silent! keeppatterns %s/\/\//\//g<CR>:silent! keeppatterns %s/[^a-zA-Z0-9\/]$//g<CR>:silent! keeppatterns g/^$/d _<CR>"_dd\| :lua require('nvim.icons.fs').render()<CR>
