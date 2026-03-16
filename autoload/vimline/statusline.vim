scriptencoding utf-8

function! vimline#statusline#() abort
  let ret = ''
  let state = state()
  let mode = mode()
  let [cwd, file] = vimline#path#relative_parts()

  let ret .= '%#Chromatophore_a# '
  let ret .= mode ==# 'n' ? ' ' : mode
  let ret .= state !=# '' ? '|'. state : ''
  let ret .= vimline#indicator#searchcount()
  let ret .= '%S '

  let ret .= '%#Chromatophore_ab#'
  let ret .= s:left_sep

  let ret .= '%#Chromatophore_b#'
  "let ret .= FugitiveStatusline()
  let ret .= ' 󱉭  '
  let ret .= cwd . '/'

  let ret .= '%#Chromatophore_bc#'
  let ret .= s:left_sep

  let ret .= '%#Chromatophore_c#'
  let ret .= file
  " let ret .= fnamemodify(expand('%'), ':.')

  " right-aligned
  let ret .= '%='
  let ret .= '%#Chromatophore_z#'
  let ret .= vimline#recording#()
  " let ret .= "%{v:lua.require'screenkey'.get_keys()}"

  return ret
endfunction
