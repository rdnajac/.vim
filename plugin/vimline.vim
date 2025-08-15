scriptencoding=utf-8
if !has('nvim')
  finish
endif
" Note:
" "%!" is evaluated in the context of the current window and buffer, 
" while %{} items are evaluated in the context of the window that the statusline belongs to.

" TODO: special cases for help/man/quickfix windows
set winbar=%{%vim#winbar#()%}
set showcmdloc=statusline
let &laststatus = has('nvim') ? 3 : 2
" set noruler " noop if we override the statusline
" set tabline=%!MyTabline()
" set showtabline=2
  set statusline=%!vim#statusline#()
" if !has_key(environ(), 'TMUX')

" Keep the recording component up to date
augroup vimline_macro
  autocmd!
  autocmd RecordingEnter * let g:vimline_rec_reg = reg_recording()
  autocmd RecordingLeave * let g:vimline_last_reg = get(g:, 'vimline_rec_reg', '') | unlet g:vimline_rec_reg
  autocmd RecordingEnter,RecordingLeave * redrawstatus
augroup END

" Hide the statusline while in command mode
augroup vimline_cmdline
  autocmd!
  autocmd CmdlineEnter * let b:lastlaststatus = &laststatus | setlocal laststatus=0
  autocmd CmdlineLeave * if exists('b:lastlaststatus') | let &l:laststatus = b:lastlaststatus | unlet b:lastlaststatus | endif
augroup END
