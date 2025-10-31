" list functions from vim-apathy
function! list#uniq(list) abort
  let i = 0
  let seen = {}
  while i < len(a:list)
    let str = string(a:list[i])
    if has_key(seen, str)
      call remove(a:list, i)
    else
      let seen[str] = 1
      let i += 1
    endif
  endwhile
  return a:list
endfunction

function! list#join(...) abort
  let val = []
  for arg in a:000
    if type(arg) == type([])
      call add(val, join(map(copy(arg), 'escape(v:val, ", ")'), ','))
    else
      call add(val, arg)
    endif
    unlet arg
  endfor
  let str = join(val, ',')
  return substitute(str, '\m,\@<!,$', ',,', '')
endfunction

function! list#split(...) abort
  let val = []
  for arg in a:000
    if type(arg) == type([])
      call extend(val, arg)
    elseif !empty(arg)
      let split = split(arg, '\\\@<!\%(\\\\\)*\zs,')
      call map(split, 'substitute(v:val,''\\\([\\,]\)'',''\1'',"g")')
      call extend(val, split)
    endif
    unlet arg
  endfor
  return val
endfunction

