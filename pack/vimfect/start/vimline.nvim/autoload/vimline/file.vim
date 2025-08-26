let s:left_sep = '🭛'

function! vimline#file#parts() abort
  let [l:root, l:suffix] = path#relative_parts()
  let l:prefix = l:root !=# '' ? '󱉭 ' . l:root . '/' : ''
  let l:ret = ''
  let l:ret .= '%#Chromatophore_a# '
  let l:ret .= l:prefix
  let l:ret .= '%#Chromatophore_b#'
  let l:ret .= s:left_sep
  let l:ret .= l:suffix
  let l:ret .= s:left_sep
  let l:ret .= '%#Chromatophore_bc#'
  let l:ret .= s:left_sep
  let l:ret .= '%#Chromatophore_c#'
  return l:ret
endfunction
