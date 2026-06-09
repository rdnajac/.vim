scriptencoding utf-8
if !has('nvim')
  finish
endif
hi clear ALEErrorSign
hi clear ALEWarningSign
let g:ale_sign_error   = '🔥'
let g:ale_sign_warning = '💩'
let g:ale_floating_window_border =
      \ ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
