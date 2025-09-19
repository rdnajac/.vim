" Vim script to get standard paths in Vim
" for compatibility with Neovim's stdpath function
" since Vim does not have a built-in stdpath function
if has('nvim')
  finish
endif

" Defaults for each stdpath
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

  if exists('$' . env)
    return eval('$' . env)
  else
    return s:defaults[a:what]
  endif
endfunction

" Testing
echo s:stdpath('config')
echo s:stdpath('data')
echo s:stdpath('state')
echo s:stdpath('cache')
