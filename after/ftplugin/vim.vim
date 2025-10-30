setlocal commentstring=\"\ %s " add space after the comment character
setlocal formatoptions-=ro    " don't continue comments with 'o' or 'O'

nnoremap <buffer> <leader>ch <Cmd>call edit#ch()<CR>

inoremap <buffer> enc scriptencoding utf-8
