" functions for formatting buffers

" remove whitespace from doc

"https://web.archive.org/web/20230418005002/https://www.vi-improved.org/recommendations/
function! format#whitespace() abort
  if !&binary && &filetype != 'diff'
    normal mz
    normal Hmy
    %s/\s\+$//e
    normal 'yz<CR>
    normal z
  endif
endfunction

function! format#whitespace2() abort
  if &binary || &filetype == 'diff'
    return
  endif

  let save_cursor = getpos('.')
  let save_view = winsaveview()

  let initial_size = line2byte(line('$') + 1) - 1

  %s/\s\+$//e

  let final_size = line2byte(line('$') + 1) - 1
  echomsg "Stripped " . (initial_size - final_size) . " bytes of trailing whitespace."

  call setpos('.', save_cursor)
  call winrestview(save_view)
endfunction

" function! StripTrailingWhitespace_n() abort
"   call StripTrailingWhitespace()
" _
"   " insert final newline if it doesn't exist
"   let last_line = line('$')
"   if last_line > 1 && getline(last_line) !~? '^\s*$'
"     call append(last_line, '')
"   endif
" endfunction
