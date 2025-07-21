function! ui#docsymbols#line() abort
  return luaeval('require("util.lualine").docsymbols()')
endfunction
