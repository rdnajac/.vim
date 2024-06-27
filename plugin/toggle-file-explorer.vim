" smartly open netrw using scp:// when editing remote files
function! Xexplore()
  let cmd = "Lexplore"            " set default command
  if expand('%:p') =~ '^scp://'   " check if current file is on remote server
    cmd .= ' scp://' . substitute(expand('%:p'), '^scp://\([^/]\+\)/', '', '') . '/'
  endif
  execute cmd
endfunction
nnoremap <leader>x :silent! call Xexplore()<CR>
