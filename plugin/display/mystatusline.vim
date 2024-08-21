" statusline configuration

" Left-align
" ==========
set statusline=			" Clear the status line
" set statusline+=\ %F\ %y\ %r    " File path, modified flag, file type, read-only flag
"set statusline+=%{FugitiveStatusline()}
set statusline+=👾
set statusline+=\ %F
set statusline+=\ %m
set statusline+=\ %y


" Right-align 
" ===========
set statusline+=%=              
" set statusline+=ascii:\ %3b\ hex:\ 0x%02B\ " ASCII and hex value of char under cursor
set statusline+=%S
set statusline+=\ [%2v,\%P]

