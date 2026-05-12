function! n#vim_has(expr, ...) abort
  return has('nvim') && (a:0 ? luaeval(a:expr, a:1) : luaeval(a:expr))
endfunction

function! n#vim_has_global(var) abort
  return n#vim_has('_G[_A] ~= nil', a:var)
endfunction

function! n#vim_has_package(var) abort
  return n#vim_has('package.loaded[_A] ~= nil', a:var)
endfunction
