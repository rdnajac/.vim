" TODO: requires surround... maybe move to surround dedicated plugin
" change the closest quote to the other type (single to double or vice versa)
"   'string'
"   "string"

function! s:toggle(q) abort
	  return 'cs' . a:q . (a:q ==# '"' ? "'" : '"')
endfunction

" 'change quote'
function! change#quote() abort
  let line = getline('.')
  let ccol = col('.') - 1
  let len = len(line)

  for d in range(0, max([ccol, len - ccol - 1]))
    for i in [ccol - d, ccol + d]
      if i >= 0 && i < len
	let q = line[i]
	if q ==# '"' || q ==# "'"
	  return s:toggle(q)
	endif
      endif
    endfor
  endfor
  return ''
endfunction

function! change#quote2() abort
  let pos = getpos('.')
  let curcol = pos[2]
  let f = searchpos('["'']', 'nW')
  let b = searchpos('["'']', 'bnW')

  if empty(f) && empty(b)
    return ''
  endif

  if empty(b) || (!empty(f) && f[1] - save[2] <= save[2] - b[1])
    let q = getline(f[0])[f[1] - 1]
  else
    let q = getline(b[0])[b[1] - 1]
  endif

  return s:toggle(q)
endfunction
