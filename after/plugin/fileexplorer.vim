" This file builds off of the netrw plugin that ships with vim
" as well as tpope's vim-vinegar plugin 

" netrw settings
let g:netrw_liststyle =  3
let g:netrw_winsize = 25

" smartly open netrw using scp:// when editing remote files
function! Xexplore()
    let cmd = "Lexplore"            " set default command
    if expand('%:p') =~ '^scp://'   " check if current file is on remote server
        cmd .= ' scp://' . substitute(expand('%:p'), '^scp://\([^/]\+\)/', '', '') . '/'
    endif
    execute cmd
endfunction
nnoremap <leader><Tab> :call Xexplore()<CR>

