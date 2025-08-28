" TODO: add padding
function! vimline#statusline#meta() abort
  let l:state = state()
  let l:mode = mode()
  let l:ret = ''
  if mode[0] ==# 'i'
    " FIXME: 
    " let l:ret .= lua#require('plug.blink', 'component')
    let l:ret .= v:lua.require'plug.blink'.component()
  elseif mode ==# 'n'
    let l:ret .= ' ' 
  endif
  let l:ret .= state !=# '' ? '|'. state : ''
  let l:ret .= vimline#indicator#searchcount()
  " let l:ret .= vimline#recording()
  return ret
endfunction

" -- TODO: move to winbar?
function s:term() abort
  " if bufname('%') =~# '^term://'
  let l:prefix = '󱉭 ' . $PWD . ' '
  let l:suffix = 'channel: ' . &channel
  return [l:prefix, l:suffix]
endfunction

let s:left_sep = '🭛'

function! vimline#statusline#() abort
  let l:ret = ''
  let l:ret .= '%#Chromatophore_a# '
  " let l:ret .= '%-12(%{vimline#statusline#meta()}%)%S'
  let l:ret .= vimline#statusline#meta() . '%S' . ' '
  let l:ret .= '%#Chromatophore_b# '
  let l:ret .= '%f' " file name
  let l:ret .= ' %#Chromatophore_bc#'
  let l:ret .= s:left_sep
  let l:ret .= ' %#Chromatophore_c#'
  " let l:ret .= lua#require('vimline', 'lua_icons')

  return l:ret
endfunction
