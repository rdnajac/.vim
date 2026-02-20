" OSC 7 format: ESC ] 7 ; file://host/path ESC \
let s:OSC7 = '\e]7;file://'

function! s:is_osc7(seq) abort
  return a:seq =~# s:OSC7
endfunction

function! term#print_request() abort
  if s:is_osc7(v:termrequest)
    Warn v:termrequest
  else
    Info v:termrequest
  endif
endfunction

function! term#handleOSC7() abort
  if !s:is_osc7(v:termrequest)
    return
  endif
  let dir = substitute(v:termrequest, '\e]7;file://[^/]*', '', '')
  " let dir = substitute(dir, '\e\\', '', '')
  if isdirectory(dir) && getcwd() !=# dir
    " Info 'OSC 7 dir change to ' . dir
    execute 'lcd' fnameescape(dir)
  endif
endfunction
