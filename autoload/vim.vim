function! vim#home() abort
  return has('nvim') ? stdpath('config') : split(&rtp, ',')[0]
endfunction

" configure vim-specific settings
function! vim#rc() abort
  let l:home = vim#home()
  let &viminfofile = home . '.viminfo'
  let &verbosefile = home . '.vimlog.txt'

  " some settings are default in nvim
  set autoread
  set wildoptions=pum,tagfile
endfunction
