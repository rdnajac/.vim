function! vim#home() abort
  return has('nvim') ? stdpath('config') : split(&rtp, ',')[0]
endfunction

" configure vim-specific settings
function! vim#rc() abort
  let &viminfofile = vim#home . '.viminfo'
  let &verbosefile = vim#home . '.vimlog.txt'

  " some settings are default in nvim
  set autoread
endfunction
