" let g:vimrc#dir = split(&runtimepath, ',')[0]
let g:vimrc#dir = fnamemodify($MYVIMRC, ':h')
let $VIMDIR = g:vimrc#dir

function! vimrc#setmarks() abort
  for num in range(1, line('$'))
    if getline(num) =~? '^"\s*Section:\s*\zs.'
      let char = matchstr(getline(num), '^"\s*Section:\s*\zs.')
      call setpos("'" . toupper(char), [0, num, 1, 0])
    endif
  endfor
endfunction

function! vimrc#apathy(...) abort
  let orig = getbufvar('', '&path')
  let new = list#join(list#uniq(call('list#split', a:000 + [orig])))
  " let new = list#prepend(orig, a:000)
  call setbufvar('', '&path', new)
  return new
endfunction
