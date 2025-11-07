setlocal formatoptions-=ro
" makes autoloaded functions easier to `ciw`
setlocal iskeyword-=#
setlocal commentstring=\"\ %s

nnoremap <buffer> <leader>ch <Cmd>call edit#ch()<CR>
nnoremap <buffer> gch        <Cmd>call edit#ch()<CR>

ia <buffer> enc scriptencoding utf-8
