if exists('g:loaded_ooze') || !has('nvim')
  finish
endif
let g:loaded_ooze = 1

if !exists('g:ooze_auto_advance')  | let g:ooze_auto_advance  = 1 | endif
if !exists('g:ooze_auto_scroll')   | let g:ooze_auto_scroll   = 1 | endif
if !exists('g:ooze_auto_exec')     | let g:ooze_auto_exec     = 1 | endif
if !exists('g:ooze_skip_comments') | let g:ooze_skip_comments = 1 | endif
if !exists('g:ooze_cr') | let g:ooze_cr = 1 | endif

nnoremap <leader><CR> <Cmd>call ooze#init()<CR>
nnoremap <CR> <Cmd>call ooze#line()<CR>
nnoremap <M-CR> <Cmd>call ooze#file()<CR>

augroup ooze
  autocmd!
  autocmd TermOpen * let g:ooze_channel = &channel
  autocmd TermOpen * let g:ooze_buffer = bufnr('%')
  " autocmd TermClose * unlet! g:ooze_channel
augroup END

