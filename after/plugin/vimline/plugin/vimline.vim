scriptencoding=utf-8

function! MyTabline() abort
  let l:line = ''
  let l:line .= '%#Chromatophore_c# '
  let l:line .= vimline#components#docsymbols()
  let l:line .= '%#Normal#'
  return l:line
endfunction

if exists('nvim')
  augroup RecordingStatus
    autocmd!
    autocmd RecordingEnter,RecordingLeave * redrawstatus
  augroup END
endif

function MyStatusline() abort
  let l:line = ''
  let l:line .= '%#Chromatophore_y#'
  " let line .= '%<'                " Left: truncated file path
  " let line .= '%f'                " filename
  " let line .= '%w'                " preview window flag

  let l:line .= vimline#components#docsymbols()
  let l:line .= ' %='               " Right alignment
  let l:line .= vimline#components#blink()
  let l:line .= '%{ exists("b:keymap_name") ? "<" .. b:keymap_name .. "> " : "" }'
  let l:line .= '%{ &busy > 0 ? "◐ " : "" }'
  let l:line .= vimline#icons#recording()
  let l:line .= ' %S '
  let l:line .= vimline#components#mode()
  return line
endfunction

function! MyTmuxline() abort
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
  let l:line .= vimline#flags() . ' '
  return l:line
endfunction

function! Clock() abort
  let l:line = ''
  let l:line .= '%='
  let l:line .= '%#Chromatophore_z#'
  let l:line .= '   ' . strftime('%T') . ' '
  let l:line .= '%#Normal#'
  return l:line
endfunction

" export the statusline
function! TmuxLeft() abort
  return luaeval("require('util.tmuxline')(vim.fn['MyTmuxline']())")
endfunction

function! TmuxRight() abort
  return luaeval("require('util.tmuxline')(vim.fn['Clock']())")
endfunction

set showcmdloc=statusline
set statusline=%!MyStatusline()
let &laststatus = has('nvim') ? 3 : 2
" set noruler
" set tabline=%!MyTabline()
" set showtabline=2
" set winbar=%!MyWinbar()
