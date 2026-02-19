" confirm  - if 1, reads a single keypress and passes 0/1 to callback
" default  - default text for input() (non-confirm only)
function! vim#prompt#(msg, callback, ...) abort
  let l:opts = get(a:, 1, {})
  echohl Question
  if get(l:opts, 'confirm', 0)
    echo a:msg . ' (y/n) '
    echohl None
    let l:answer = nr2char(getchar())
    call a:callback(l:answer ==? 'y')
  else
    let l:answer = input(a:msg . ' ', get(l:opts, 'default', ''))
    echohl None
    call a:callback(l:answer)
  endif
endfunction
