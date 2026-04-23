scriptencoding utf-8
setlocal iskeyword-=#          " makes autoloaded functions easier to `ciw`
setlocal commentstring=\"\ %s  " bette foldmarkers with `zf`

" TODO: use `:h 'formatlistpat'`
inoremap <buffer><expr> <CR> getline('.') =~# "^\\s*Plug '" ? "<CR>Plug ''\<Left>" : '<CR>'
nnoremap <buffer><expr> o    getline('.') =~# "^\\s*Plug '" ? "oPlug ''\<Left>" : 'o'
nnoremap <buffer><expr> O    getline('.') =~# "^\\s*Plug '" ? "OPlug ''\<Left>" : 'O'

" nemonic 'change header?'
nnoremap <buffer> gch <Cmd>call edit#ch()<CR>

" xnoremap <buffer> <CR> :\|echom join(['##  ', '```vim', getline('.'), '```'], "\n")<CR>
xnoremap <buffer> <CR> :<C-U><C-R><C-L>\|echo "##  \n```vim\n"..getline('.').."\n```"<CR>
nnoremap <buffer> <M-CR> <Cmd>so % \| echom 'Sourced ' .. expand('%:p')<CR>

nnoremap <buffer> yu viWyo<Esc>p0iechom<Space><Esc>

ia <buffer> enc scriptencoding utf-8
