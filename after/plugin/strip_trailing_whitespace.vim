function! StripTrailingWhitespace()
  if !&binary && &filetype != 'diff'
    let l:save_cursor = getpos(".")
    let l:save_view = winsaveview()
    %s/\s\+$//e
    call setpos('.', l:save_cursor)
    call winrestview(l:save_view)
  endif
endfunction
nnoremap <leader>w :call StripTrailingWhitespace()<CR> :w<CR>
