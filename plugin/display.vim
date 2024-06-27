" display defaults
set showtabline=2
set tabline=%!display#MyTabline()
set showcmd
set laststatus=0
"set showcmdloc=statusline   " show command in statusline 
set cmdheight=1              " height of the command line
set statusline=				    " Clear the status line
set statusline+=\ %F\ %y\ %r          " File path, modified flag, file type, read-only flag
"set statusline+=%{FugitiveStatusline()}   " Git branch
set statusline+=%=                        " Right align the following items
" set statusline+=ascii:\ %3b\ hex:\ 0x%02B\ " ASCII and hex value of char under cursor
" line length: %3l, column: %2c, percentage through file: %3p, total lines: %L
" add ling length to statusline
set statusline+=strwidth=%{strwidth(getline('.'))} 
set statusline+=\ [%2v,\%P]

function! ToggleOverlay()
  if &showtabline == 2
    set showtabline=0
    set laststatus=2
  else
    set showtabline=2
    set laststatus=0
  endif
endfunction
nnoremap <leader>i :call ToggleOverlay()<CR>
