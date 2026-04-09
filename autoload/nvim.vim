function! nvim#has(expr, ...) abort
  return has('nvim') && (a:0 ? luaeval(a:expr, a:1) : luaeval(a:expr))
endfunction

function! nvim#has_global(var) abort
  return nvim#has('_G[_A] ~= nil', a:var)
endfunction

function! nvim#has_package(var) abort
  return nvim#has('package.loaded[_A] ~= nil', a:var)
endfunction
