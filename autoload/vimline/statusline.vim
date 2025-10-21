scriptencoding utf-8
let s:left_sep = '🭛'

function! vimline#statusline#() abort
  let l:state = state()
  let l:mode = mode()
  let [l:prefix, l:suffix] = path#relative_parts()
  " let l:prefix = l:root !=# '' ? ' 󱉭  ' . l:root . '/' : ''

  let l:ret = ''
  let l:ret .= '%#Chromatophore_a# '
  let l:ret .= mode ==# 'n' ? ' ' : l:mode
  let l:ret .= state !=# '' ? '|'. state : ''
  let l:ret .= vimline#indicator#searchcount()
  let l:ret .= '%S '
  " let l:ret .= '%#Chromatophore_b#'
  " let l:ret .= '%#Chromatophore_ab#'
  " let l:ret .= s:left_sep
  let l:ret .= l:prefix
  let l:ret .= '%#Chromatophore_ab#'
  let l:ret .= s:left_sep
  let l:ret .= '%#Chromatophore_b#'
  let l:ret .= l:suffix
  let l:ret .= '%#Chromatophore_bc#'
  let l:ret .= s:left_sep
  " TODO: add to right-align
  " let l:ret .= vimline#recording()
  return l:ret
endfunction
