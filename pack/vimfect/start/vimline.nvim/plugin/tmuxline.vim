scriptencoding=utf-8

if !has_key(environ(), 'TMUX')
  finish
endif

function! s:tmuxline(fn) abort
  return luaeval("require('vimline.tmuxline')(vim.fn[_A]())", a:fn)
endfunction

function! Clock() abort
  return '%=%#Chromatophore_z#   ' . strftime('%T') . ' %#Normal#'
endfunction

function! TmuxLeft() abort
  return s:tmuxline('MyTmuxLine')
endfunction

function! TmuxRight() abort
  return s:tmuxline('Clock')
endfunction
