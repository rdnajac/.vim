setlocal formatoptions-=ro
" makes autoloaded functions easier to `ciw`
setlocal iskeyword-=#
setlocal commentstring=\"\ %s
setlocal nowrap

nnoremap <buffer> <leader>ch <Cmd>call edit#ch()<CR>
nnoremap <buffer> gch        <Cmd>call edit#ch()<CR>

nnoremap <buffer> <M-CR> <Cmd>so %<CR>

ia <buffer> enc scriptencoding utf-8
