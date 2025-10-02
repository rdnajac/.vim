" functions for checking if things are things in vim
function! is#comment() abort
  if a:0 >= 2
    let lnum = a:1
    let col  = a:2
  else
    let lnum = line('.') - 1
    let col  = col('.') - 1
  endif

  let synid = synID(lnum + 1, col + 1, 1)
  let name  = synIDattr(synid, 'name')
  return !empty(name) && name =~# 'Comment'
endfunction
