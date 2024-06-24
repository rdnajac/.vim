" This file contains all settings, global variables, and key mappings for
" plugins related to file management in Vim, including netrw and fzf.

" TODO ensure installed....

" netrw settings
let g:netrw_liststyle =  3
let g:netrw_winsize = 25


" fzf settings
" there are two plugins:
"   - junegunn/fzf.vim: provides a :FZF command to open fzf in a new window
"   - junegunn/fzf: the actual fzf command line tool
"
" Don't forget to install fzf with the following command:
" fzf#install()
"
" We have fzf installed via Homebrew, so let's avoid re-installing it...

" set rtp+=/opt/homebrew/opt/fzf
" Ideally I don't want to manipulate the path, but let's see if this works...


" smartly open netrw using scp:// when editing remote files
function! Xexplore()
    let cmd = "Lexplore"            " set default command
    if expand('%:p') =~ '^scp://'   " check if current file is on remote server
        cmd .= ' scp://' . substitute(expand('%:p'), '^scp://\([^/]\+\)/', '', '') . '/'
    endif
    execute cmd
endfunction
nnoremap <leader><Tab> :silent! call Xexplore()<CR>
