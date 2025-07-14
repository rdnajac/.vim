scriptencoding=utf-8

function! s:ft_icon() abort
  return v:lua.require('util.lualine.components.filetype_icon')()
endfunction

let s:sep = '│'
function! s:flags() abort
  let l:out = ''
  let l:out .= s:ft_icon()
  let l:out .= ' '
  let l:out .= &readonly    ? s:sep . ' ' : ''
  let l:out .= &filetype ==# 'help' ? s:sep . '%h' : ''
  let l:out .= &modified   ? s:sep . ' '  : ''
  return l:out
endfunction

function! MyStatusline() abort
  let [l:root, l:suffix] = git#RelativePath()
  let l:prefix = l:root !=# '' ? '󱉭 ' . l:root . '/' : ''
  let l:line = ''
  let l:line .= '%#Chromatophore_a# '
  let l:line .= l:prefix
  let l:line .= '%#Chromatophore_ab#🭛'
  let l:line .= '%#Chromatophore_b#'
  let l:line .= l:suffix
  let l:line .= ' %#Chromatophore_bc#🭛'
  let l:line .= '%#Chromatophore_c#'
  let l:line .= s:flags() . ' '
  return l:line
endfunction

function! MyTabline() abort
  let l:line = ''
  " let l:line .= '%#Chromatophore_bc#🭛'
  let l:line .= '%='
  let l:line .= '%#Chromatophore_z#'
  " let l:line .= ui#components#ft_icon() .. ' '
  let l:line .= '   ' . strftime('%T') . ' '
  let l:line .= '%#Normal#'
  return l:line
endfunction

" export the statusline
function! TmuxLeft() abort
  return luaeval("require('util.tmuxline')(vim.fn['MyStatusline']())")
endfunction

function! TmuxRight() abort
  return luaeval("require('util.tmuxline')(vim.fn['MyTabline']())")
endfunction

" statusline=%<%f %h%w%m%r %=%{% &showcmdloc == 'statusline' ? '%-10.S ' : '' %}%{% exists('b:keymap_name') ? '<'..b:keymap_name..'> ' : '' %}%{% &busy > 0 ? '◐ ' : '' %}%{% &ruler ? ( &rulerformat == '' ? '%-14.(%l,%c%V%) %P' : &rulerformat ) : '' %}
