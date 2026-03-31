" vimscript to get standard paths in vim since it
" does not have a built-in `stdpath()`, like nvim
" also see see `$VIMRUNTIME/xdg.vim` if vim92
let s:paths = {
      \ 'config': $HOME . '/.config',
      \ 'data':   $HOME . '/.local/share',
      \ 'state':  $HOME . '/.local/state',
      \ 'cache':  $HOME . '/.cache',
      \ }

function! s:stdpath(what) abort
  if !has_key(s:paths, a:what)
    throw printf('s:stdpath(): invalid argument "%s"', a:what)
  endif

  " Make ENV var name, e.g. config -> XDG_CONFIG_HOME
  let env = printf('$XDG_%s_HOME', toupper(a:what))

  if !exists(env) || empty(eval(env))
    execute printf('let %s = %s', env, string(s:paths[a:what]))
  endif
  return eval(env)
endfunction

" dictionary of a subset of stdpath values to reduce overhead of calling
" `stdpath()` multiple times in various places; also works in vim,
" which does not have `stdpath()`, but supports XDG env vars
let g:stdpath = reduce(keys(s:paths),
      \ {acc, k -> extend(acc, {k: exists('*stdpath') ? stdpath(k) : s:stdpath(k) . '/vim'})}, {} )
