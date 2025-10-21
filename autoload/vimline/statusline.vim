scriptencoding utf-8
let s:left_sep = '🭛'

function! s:file() abort
  let [l:root, l:suffix] = path#relative_parts()
  let l:prefix = l:root !=# '' ? ' 󱉭  ' . l:root . '/' : ''
  let l:ret = ''
  let l:ret .= '%#Chromatophore_b#'
  let l:ret .= l:prefix
  let l:ret .= '%#Chromatophore_bc#'
  let l:ret .= s:left_sep
  let l:ret .= '%#Chromatophore_c#'
  let l:ret .= l:suffix
  return l:ret
endfunction

function! vimline#statusline#() abort
  let l:state = state()
  let l:mode = mode()

  let l:ret = ''
  let l:ret .= '%#Chromatophore_a# '
  let l:ret .= mode ==# 'n' ? ' ' : l:mode
  let l:ret .= state !=# '' ? '|'. state : ''
  let l:ret .= vimline#indicator#searchcount()
  " let l:ret .= vimline#recording()
  let l:ret .= '%S '
  let l:ret .= s:file()
  return l:ret
endfunction
