autocmd FileType vim setlocal formatoptions-=ro

nnoremap <buffer> <leader>ch <Cmd>call edit#ch()<CR>
nnoremap <buffer> gch        <Cmd>call edit#ch()<CR>

ia <buffer> enc scriptencoding utf-8
