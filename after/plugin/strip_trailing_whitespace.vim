function! StripTrailingWhitespace()
  if !&binary && &filetype != 'diff'
    let l:save_cursor = getpos(".")
    let l:save_view = winsaveview()
    silent! %s/\s\+$//e
    call setpos('.', l:save_cursor)
    call winrestview(l:save_view)
  endif
endfunction
nnoremap <F2> :call StripTrailingWhitespace()<CR> :w<CR>
