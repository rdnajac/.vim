" autoload everything!
function! my#vimrc() abort
  if has('nvim') && filereadable(stdpath('config') . '/init.lua')
    return stdpath('config') . '/vimrc'
  endif
  return $MYVIMRC
endfunction

