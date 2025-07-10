function! change#quote() abort
  let line = getline('.')
  let col = col('.')
  let q = ''

  for i in range(col - 1, 0, -1)
    let c = line[i - 1]
    if c ==# '"' || c ==# "'"
      let q = c
      break
    endif
  endfor

  return q ==# '' ? '' : 'cs' . q . (q ==# '"' ? "'" : '"')
endfunction
