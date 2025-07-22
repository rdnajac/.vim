function vimline#tmuxline#left() abort
  return luaeval("require('vimline.tmuxline')(vim.fn['MyTmuxline']())")
endfunction

function vimline#tmuxline#right() abort
  return luaeval("require('vimline.tmuxline')(vim.fn['Clock']())")
endfunction
