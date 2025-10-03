scriptencoding utf-8
let s:left_sep = '🭛'
let s:flags = {
      \ 'modified': { -> &modified ? ' ' : '' },
      \ 'readonly': { -> &readonly ? ' ' : '' },
      \ 'busy': { -> &busy ? '◐ ' : '' },
      \ }

function! vimline#flag(name) abort
  return has_key(s:flags, a:name) ? s:flags[a:name]() : ''
endfunction

function! vimline#file() abort
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

function! vimline#statusline() abort
  let l:state = state()
  let l:mode = mode()

  let l:ret = ''
  let l:ret .= '%#Chromatophore_a# '
  let l:ret .= mode ==# 'n' ? ' ' : l:mode
  let l:ret .= state !=# '' ? '|'. state : ''
  let l:ret .= vimline#indicator#searchcount()
  " let l:ret .= vimline#recording()
  let l:ret .= '%S '
  let l:ret .= vimline#file()
  return l:ret
endfunction
