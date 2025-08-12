" safely call a snack function from vimscript

" if luaeval('_G.Snacks ~= nil')
"   call vim#notify#('Snacks is already loaded')
" else
"   call vim#notify#('Loading Snacks...')
" endif

" function! nvim#snacks#(snack, ...) abort
function! vim#lua#snacks(snack) abort
  " if has('nvim') && luaeval("_G.Snacks ~= nil or package.loaded['Snacks'] ~= nil")
  " if a:0
  " call luaeval('Snacks[_A[1]](_A[2])', [a:snack, a:1])
  " else
  " call luaeval('Snacks[_A]()', a:snack)
  " FIXME:
  exec 'call v:lua.Snacks.' . a:snack . '()'
  " endif

  " call vim#notify#error('no Snacks...')

endfunction
