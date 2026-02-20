" confirm  - if 1, reads a single keypress and passes 0/1 to callback
" default  - default text for input() (non-confirm only)
function! vim#prompt#(msg, callback, ...) abort
  let opts = get(a:, 1, {})
  echohl Question
  if get(opts, 'confirm', 0)
    echo a:msg . ' (y/n) '
    echohl None
    let answer = nr2char(getchar())
    call a:callback(answer ==? 'y')
  else
    let answer = input(a:msg . ' ', get(opts, 'default', ''))
    echohl None
    call a:callback(answer)
  endif
endfunction
