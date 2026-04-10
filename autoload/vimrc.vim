" let g:vimrc#dir = split(&runtimepath, ',')[0]
let g:vimrc#dir = fnamemodify($MYVIMRC, ':h')

function! vimrc#setmarks() abort
  for num in range(1, line('$'))
    if getline(num) =~? '^"\s*Section:\s*\zs.'
      let char = matchstr(getline(num), '^"\s*Section:\s*\zs.')
      call setpos("'" . toupper(char), [0, num, 1, 0])
    endif
  endfor
endfunction

function! vimrc#insert_unique(bufvar, ...) abort
  let orig = getbufvar('', a:bufvar)
  let val = list#join(list#uniq(call('list#split', a:000 + [orig])))
  call setbufvar('', a:bufvar, val)
  return val
endfunction

" like `apathy#Prepend()` but only for path
function! vimrc#apathy(...) abort
  return(vimrc#insert_unique('path', a:000))
endfunction
