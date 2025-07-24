scriptencoding=utf-8

if !has('nvim')
  finish
endif

set showcmdloc=statusline
set statusline=%!MyStatusline()
let &laststatus = has('nvim') ? 3 : 2
" set noruler
" set tabline=%!MyTabline()
" set showtabline=2
" set winbar=%!MyWinbar()

function MyStatusline() abort
  let l:line = ''
  " let line .= '%<'                " Left: truncated file path
  " let line .= '%f'                " filename
  " let line .= '%w'                " preview window flag

  " let l:line .= vimline#components#docsymbols()
  let l:line .= ' %='               " Right alignment
  " let l:line .= vimline#components#lspprogress()
  let l:line .= '%#Black#'
  let l:line .= ''
  let l:line .= '%#Chromatophore_y#'
  let l:line .= '%{ &busy > 0 ? "◐ " : "" }'
  let l:line .= vimline#components#blink()
  let l:line .= ' '
  let l:line .= vimline#recording()
  let l:line .= ' %S '
  " let l:line .= vimline#components#mode()
  " let l:line .= printf('%-10s', vimline#components#mode())
  let l:line .= printf('%10s', vimline#components#mode())
  let l:line .= '%#Black#'
  let l:line .= ''
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
  return luaeval("require('vimline.tmuxline')(vim.fn['MyTmuxline']())")
endfunction

function! TmuxRight() abort
  return luaeval("require('vimline.tmuxline')(vim.fn['Clock']())")
endfunction

augroup vimline_macro
  autocmd!
  autocmd RecordingEnter * let g:vimline_rec_reg = reg_recording()
  autocmd RecordingLeave * let g:vimline_last_reg = get(g:, 'vimline_rec_reg', '') | unlet g:vimline_rec_reg
  autocmd RecordingEnter,RecordingLeave * redrawstatus
augroup END
