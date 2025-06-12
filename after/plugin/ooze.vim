if exists('g:loaded_ooze') || &cp || v:version < 700
  finish
endif
let g:loaded_ooze = 1

" if !(exists(expr)... save a directory as a global variable to move back 
" to the pinned directory

command! -range=% OozeVisual call ooze#visual()
