" autoload/plug.vim
function! plug#init() abort
  let s:dst = expand('<script>:p')
  let s:url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

  if delete(s:dst) == -1
    echoerr 'Failed to self-destruct: ' . s:dst
    return
  endif

  let s:cmd = printf('curl -fsSL %s -o %s', shellescape(s:url), shellescape(s:dst))
  let s:code = system(s:cmd)

  if v:shell_error
    echoerr 'Failed to fetch vim-plug: ' . s:cmd
  else
    echom 'vim-plug installed to ' . s:dst
  endif
endfunction
