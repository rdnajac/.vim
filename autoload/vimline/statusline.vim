scriptencoding utf-8
let s:left_sep = '🭛'

function! vimline#statusline#() abort
  let l:ret = ''
  let l:state = state()
  let l:mode = mode()
  let [l:cwd, l:file] = path#relative_parts()

  let l:ret .= '%#Chromatophore_a# '
  let l:ret .= mode ==# 'n' ? ' ' : l:mode
  let l:ret .= state !=# '' ? '|'. state : ''
  let l:ret .= vimline#indicator#searchcount()
  let l:ret .= '%S '

  let l:ret .= '%#Chromatophore_ab#'
  let l:ret .= s:left_sep

  let l:ret .= '%#Chromatophore_b#'
  let l:ret .= '󱉭 ' . l:cwd . '/'

  let l:ret .= '%#Chromatophore_bc#'
  let l:ret .= s:left_sep

  let l:ret .= '%#Chromatophore_c#'
  let l:ret .= l:file
  " let l:ret .= fnamemodify(expand('%'), ':.')

  " right-aligned
  let l:ret .= '%='

  let l:ret .= '%#Chromatophore_z#'
  let l:ret .= vimline#recording#()

  return l:ret
endfunction
