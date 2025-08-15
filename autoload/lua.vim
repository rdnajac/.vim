" autoload/lua.vim

" TODO: fail gracefully?
function! s:if_vim_handle() abort
  if !has('nvim')
    throw 'This function is only available in Neovim'
  endif
endfunction

function! lua#eval(module, method, ...) abort
  call s:if_vim_handle()
  return luaeval('require(_A[1])[_A[2]](unpack(_A[3]))', [a:module, a:method, a:000])
endfunction

""
" vint doesn't like `v:lua` so we use a wrapper function
" NOTE: no args
function! lua#require(module, method) abort
  return v:lua.require(a:module)[a:method]()
endfunction

" safely call a snack function from vimscript

" if luaeval('_G.Snacks ~= nil')
"   call vim#notify#('Snacks is already loaded')
" else
"   call vim#notify#('Loading Snacks...')
" endif

" function! nvim#snacks#(snack, ...) abort
function! lua#snacks(snack) abort
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
