set statusline=%!vimline#statusline#()

if !has('nvim')
  finish
endif

" TODO: rewrite winbar in lua since its nvim only
set winbar=%{%vimline#winbar#()%}

augroup vimline
  autocmd!

  " Keep the recording component up to date
  autocmd RecordingEnter * let g:vimline_rec_reg = reg_recording()
  autocmd RecordingLeave * let g:vimline_last_reg = get(g:, 'vimline_rec_reg', '') | unlet g:vimline_rec_reg
  autocmd RecordingEnter,RecordingLeave * redrawstatus
augroup END
