" functions for checking if things are things in vim
function is#comment() abort
  let pos = getpos('.')
  let synid = synID(pos[1], pos[2], 1)
  let name  = synIDattr(synid, 'name')
  return !empty(name) && name =~# 'Comment'
endfunction
