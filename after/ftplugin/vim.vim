setlocal formatoptions-=ro

" Continue `\ ` list lines on <CR> (like bullet continuation)
inoremap <buffer><expr> <CR> getline('.') =~# '^\s*\\\ ' ? '<CR>\ ' : '<CR>'
nnoremap <buffer><expr> o getline('.') =~# '^\s*\\\ ' ? 'o\ ' : 'o'
nnoremap <buffer><expr> O getline('.') =~# '^\s*\\\ ' ? 'O\ ' : 'O'

" makes autoloaded functions easier to `ciw`
setlocal iskeyword-=#
setlocal commentstring=\"\ %s
setlocal nowrap

nnoremap <buffer> <leader>ch <Cmd>call edit#ch()<CR>
nnoremap <buffer> gch        <Cmd>call edit#ch()<CR>

nnoremap <buffer> <M-CR> <Cmd>so %<CR>

ia <buffer> enc scriptencoding utf-8
