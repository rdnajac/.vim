function! vimline#components#docsymbols() abort
  return luaeval('require("vimline").docsymbols()')
endfunction

function! vimline#components#mode() abort
  return luaeval('require("vimline").mode()')
endfunction

function! vimline#components#blink() abort
  return luaeval('require("vimline").blink()')
endfunction
