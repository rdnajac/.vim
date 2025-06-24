if exists('g:loaded_ooze') || !has('nvim')
  finish
endif
let g:loaded_ooze = 1

augroup ooze
  au!
  au TermOpen * if &ft ==# 'snacks_terminal' | let g:ooze_channel = &channel | endif
augroup END

let g:ooze_send_on_enter = 1

nnoremap <silent><expr> <CR> ooze#cr()

command! -range=% OozeVisual call ooze#visual()
command!          OozeRunFile call ooze#runfile()

vnoremap <silent> <CR>   :OozeVisual<CR>
nnoremap <silent> <M-CR> :OozeRunFile<CR>
