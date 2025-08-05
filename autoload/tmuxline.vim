" Takes a vim function name and returns a tmuxline string.
function! s:tmuxline(fn) abort
  return luaeval("require('vimline.tmuxline')(' . a:fn . '())")
endfunction

function! tmuxline#left() abort
  return s:tmuxline('MyTmuxline')
endfunction

function! tmuxline#right() abort
  return s:tmuxline('Clock')
endfunction
