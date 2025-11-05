setlocal formatoptions-=ro
setlocal iskeyword " makes autoloaded functions easier to `ciw`
setlocal commentstring=\"\ %s

nnoremap <buffer> <leader>ch <Cmd>call edit#ch()<CR>
nnoremap <buffer> gch        <Cmd>call edit#ch()<CR>

ia <buffer> enc scriptencoding utf-8
