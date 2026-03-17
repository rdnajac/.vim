" Vim script to get standard paths in Vim
" for compatibility with Neovim's stdpath function
" since Vim does not have a built-in stdpath function
let s:defaults = {
      \ 'config': $HOME . '/.config',
      \ 'data':   $HOME . '/.local/share',
      \ 'state':  $HOME . '/.local/state',
      \ 'cache':  $HOME . '/.cache',
      \ }

function! s:stdpath(what) abort
  if !has_key(s:defaults, a:what)
    throw printf('stdpath(): invalid argument "%s"', a:what)
  endif

  " Make ENV var name, e.g. config -> XDG_CONFIG_HOME
  let env = printf('XDG_%s_HOME', toupper(a:what))

  if !exists('$' . env)
    execute printf('let $%s = %s', env, string(s:defaults[a:what]))
  endif

  return eval('$' . env)
endfunction


" dictionary of a subset of stdpath values to reduce overhead of calling
" `stdpath()` multiple times in various places; also works in vim,
" which does not have `stdpath()`, but supports XDG env vars
let g:stdpath = reduce(['cache', 'config', 'data', 'state'],
      \ {acc, k -> extend(acc, {k: exists('*stdpath') ? stdpath(k) : s:stdpath(k) . '/vim'})}, {} )
