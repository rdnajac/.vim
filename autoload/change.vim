" change the closest quote to the other type (single to double or vice versa)
"   'string'
"   "string"

function! change#quote() abort
  let line = getline('.')
  let ccol = col('.') - 1
  let len = len(line)

  for d in range(0, max([ccol, len - ccol - 1]))
    for i in [ccol - d, ccol + d]
      if i >= 0 && i < len
        let c = line[i]
        if c ==# '"' || c ==# "'"
          return 'cs' . c . (c ==# '"' ? "'" : '"')
        endif
      endif
    endfor
  endfor

  return ''
endfunction
