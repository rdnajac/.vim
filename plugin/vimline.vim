scriptencoding=utf-8
if !has('nvim')
  finish
endif

" Note that the "%!" expression is evaluated in the context of the
" current window and buffer, while %{} items are evaluated in the
" context of the window that the statusline belongs to.

set showcmdloc=statusline
set statusline=%!MyStatusLine()
let &laststatus = has('nvim') ? 3 : 2
" set noruler " noop if we override the statusline
" set tabline=%!MyTabline()
" set showtabline=2
if !has_key(environ(), 'TMUX')
  set statusline=%!MyTmuxLine()
else
  set statusline=%!MyStatusLine()
endif

" wrap the function in % 
set winbar=%{%vimline#winbar()%}
" set winbar=!%vimline#winbar(g:statusline_winid)

function StatusRight() abort
  let l:line = ''
  let l:line .= ' %='               " Right alignment
  " let l:line .= vimline#components#lspprogress()
  let l:line .= '%#Black#'
  let l:line .= '%#Chromatophore_y#'
  let l:line .= v:lua.require'vimline.components'.searchcount()
  let l:line .= mode() ==# 'n' ? ' ' : mode()
  let l:line .= '%{ &busy > 0 ? "◐ " : "" }'
  let l:line .= '%S '
  " let l:line .= vimline#recording()
  " let l:line .= vimline#luacomponent('blink')
  let l:line .= v:lua.require'vimline.components'.blink()
  let l:line .= '%#Black#'
  return line
endfunction

function s:term() abort
  " if bufname('%') =~# '^term://'
  let l:prefix = '󱉭 ' . $PWD . ' '
  let l:suffix = 'channel: ' . &channel
  return [l:prefix, l:suffix]
endfunction

" TODO: write file component
function! MyTmuxLine() abort
  let [l:root, l:suffix] = path#relative_parts()
  let l:prefix = l:root !=# '' ? '󱉭 ' . l:root . '/' : ''
  let l:line = ''
  let l:line .= '%#Chromatophore_a# '
  let l:line .= l:prefix
  let l:line .= '%#Chromatophore_b#'
  let l:line .= '🭛'
  let l:line .= l:suffix
  let l:line .= ' '
  let l:line .= '%#Chromatophore_bc#'
  let l:line .= '🭛'
  let l:line .= '%#Chromatophore_c#'
  let l:line .= vimline#flags() . ' '
  return l:line . StatusRight()
endfunction

function! Clock() abort
  let l:line = ''
  let l:line .= '%='
  let l:line .= '%#Chromatophore_z#'
  let l:line .= '   ' . strftime('%T') . ' '
  let l:line .= '%#Normal#'
  return l:line
endfunction

" export the tmux statusline
function! TmuxLeft() abort
  return vimline#tmuxline('MyTmuxLine')
endfunction

function! TmuxRight() abort
  return vimline#tmuxline('Clock')
endfunction

" Keep the recording component up to date
augroup vimline_macro
  autocmd!
  autocmd RecordingEnter * let g:vimline_rec_reg = reg_recording()
  autocmd RecordingLeave * let g:vimline_last_reg = get(g:, 'vimline_rec_reg', '') | unlet g:vimline_rec_reg
  autocmd RecordingEnter,RecordingLeave * redrawstatus
augroup END

" Hide the statusline while in command mode
augroup vimline_cmdline
  autocmd!
  autocmd CmdlineEnter * let b:lastlaststatus = &laststatus | set laststatus=0
  autocmd CmdlineLeave * if exists('b:lastlaststatus') | let &laststatus = b:lastlaststatus | unlet b:lastlaststatus | endif
augroup END
