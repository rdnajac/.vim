if exists('g:loaded_ooze') || &cp || v:version < 700
  finish
endif
let g:loaded_ooze = 1


command! -range=% OozeVisual call ooze#visual()
