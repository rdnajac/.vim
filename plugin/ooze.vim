if exists('g:loaded_ooze') || !has('nvim')
  finish
endif
let g:loaded_ooze = 1

if !exists('g:ooze_auto_advance')  | let g:ooze_auto_advance  = 1 | endif
if !exists('g:ooze_auto_scroll')   | let g:ooze_auto_scroll   = 1 | endif
if !exists('g:ooze_send_on_enter') | let g:ooze_send_on_enter = 0 | endif
if !exists('g:ooze_auto_exec')     | let g:ooze_auto_exec     = 1 | endif
if !exists('g:ooze_skip_comments') | let g:ooze_skip_comments = 1 | endif

augroup ooze
  au!
  au ChanOpen * let g:ooze_channel = &channel
  " need to capture `TermClose` event to unset g:ooze_channel
  " since thre is no `ChanClose` event
augroup END

" let g:ooze_send_on_enter = 2

nnoremap <silent><expr> <CR> ooze#cr()

command! -range=% OozeVisual call ooze#visual()
command!          OozeFile call ooze#file()

" TODO: only apply keymaps once a channel is selected
" nmap <silent> <leader><CR> <Cmd>OozeRunFile<CR>
" vnoremap <silent> <CR>   :OozeVisual<CR>
" nnoremap <silent> <M-CR> :OozeRunFile<CR>

nmap <silent> dx m':set opfunc=ooze#operator<CR>g@
