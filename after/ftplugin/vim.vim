setlocal formatoptions-=ro


inoremap <buffer><expr> <CR> getline('.') =~# "^\\s*Plug '" ? "<CR>Plug ''\<Left>" : '<CR>'
nnoremap <buffer><expr> o    getline('.') =~# "^\\s*Plug '" ? "oPlug ''\<Left>" : 'o'
nnoremap <buffer><expr> O    getline('.') =~# "^\\s*Plug '" ? "OPlug ''\<Left>" : 'O'

" makes autoloaded functions easier to `ciw`
setlocal iskeyword-=#
setlocal commentstring=\"\ %s
setlocal nowrap

nnoremap <buffer> <leader>ch <Cmd>call edit#ch()<CR>
nnoremap <buffer> gch        <Cmd>call edit#ch()<CR>

" TODO: Info
nnoremap <buffer> <M-CR> <Cmd>so % \| echom 'Sourced ' .. expand('%:p')<CR>
xnoremap <buffer> <CR> :\|echom getline('.')<CR>

ia <buffer> enc scriptencoding utf-8
