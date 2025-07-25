function! s:findhome() abort
  if has('nvim')
    return stdpath('config')
  else
    let l:parent = fnamemodify($MYVIMRC, ':p:h')
    let l:home   = expand('$HOME')

    " vim-plug finds the vim dir like this:
    " `let home = s:path(split(&rtp, ',')[0]) . '/plugged'`

    return l:parent ==# l:home ? l:home . '/.vim' : l:parent
  endif
endfunction

let vim#home = s:findhome()

" configure vim-specific settings
function! vim#rc() abort
  let &viminfofile = vim#home . '.viminfo'
  let &verbosefile = vim#home . '.vimlog.txt'

  " some settings are default in nvim
  set autoread
endfunction
