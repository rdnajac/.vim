" run commands with `:<C-R><C-L><CR>`
" create a keymap to Enter
nmap <CR> :<C-R><C-L><CR>

verbose set filetype?
echom b:current_syntax
LOL
lua require('lol').cat()
