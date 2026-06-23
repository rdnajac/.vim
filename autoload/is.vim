" true when in any visual mode (charwise, linewise, or blockwise)
function is#visual() abort
  return mode() =~# "^[vV\<C-V>]"
endfunction

function! is#comment(...) abort
  let pos = a:0 ? a:1 : getpos('.')
  let synid = synID(pos[1], pos[2], 1)
  let name = synIDattr(synid, 'name')
  return !empty(name) && name =~# 'Comment'
endfunction
