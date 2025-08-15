set winbar=%{%vimline#winbar#()%}
set statusline=%!vimline#statusline#()
" noop if we override the statusline
" set noruler
set showcmdloc=statusline

" set tabline=%!MyTabline()
" set showtabline=2

" if !has_key(environ(), 'TMUX')

augroup vimline
  autocmd!

" Keep the recording component up to date
  autocmd RecordingEnter * let g:vimline_rec_reg = reg_recording()
  autocmd RecordingLeave * let g:vimline_last_reg = get(g:, 'vimline_rec_reg', '') | unlet g:vimline_rec_reg
  autocmd RecordingEnter,RecordingLeave * redrawstatus

" Hide the statusline while in command mode
  autocmd CmdlineEnter * let b:lastlaststatus = &laststatus | setlocal laststatus=0
  autocmd CmdlineLeave * if exists('b:lastlaststatus') | let &l:laststatus = b:lastlaststatus | unlet b:lastlaststatus | endif
augroup END
