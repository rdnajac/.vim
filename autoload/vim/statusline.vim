" TODO: add padding
function! vim#statusline#right() abort
  let l:state = state()
  let l:mode = mode()
  let l:ret = '%='
  let l:ret .= v:lua.require'vimline.components'.searchcount()
  let l:ret .= mode ==# 'n' ? ' ' : mode
  let l:ret .= state !=# '' ? '|'. state : ''
  let l:ret .= '%{ &busy > 0 ? "◐ " : "" }'
  let l:ret .= '%S'
  " let l:ret .= vimline#recording()
  " let l:ret .= vimline#luacomponent('blink')
  let l:ret .= mode[0] ==# 'i' ? v:lua.require'vimline.components'.blink() : ''
  return ret
endfunction

function s:term() abort
  " if bufname('%') =~# '^term://'
  let l:prefix = '󱉭 ' . $PWD . ' '
  let l:suffix = 'channel: ' . &channel
  return [l:prefix, l:suffix]
endfunction

let s:left_sep = '🭛'

function! vim#statusline#file_parts() abort
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

function! vim#statusline#a() abort
  return '%f'
endfunction

function! vim#statusline#() abort
  let l:ret = ''
  let l:ret .= '%#Chromatophore_b# '
  let l:ret .= vim#statusline#a()
  let l:ret .= ' %#Chromatophore_bc#'
  let l:ret .= s:left_sep
  let l:ret .= ' %#Chromatophore_c#'
  let l:ret .= vimline#flags()
  let l:ret .= vim#statusline#right()

  return l:ret
endfunction
