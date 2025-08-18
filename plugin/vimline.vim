set statusline=%!vimline#statusline#()

augroup vimline_nvim
  autocmd!
  " Hide the statusline while in command mode
  autocmd CmdlineEnter * if &ls != 0            | let g:last_ls = &ls | set ls=0        | endif
  autocmd CmdlineLeave * if exists('g:last_ls') | let &ls = g:last_ls | unlet g:last_ls | endif
augroup END

if !has('nvim')
  finish
endif

" TODO: rewrite winbar in lua since its nvim only
set winbar=%{%vimline#winbar#()%}

augroup vimline_nvim
  autocmd!

  " Keep the recording component up to date
  autocmd RecordingEnter * let g:vimline_rec_reg = reg_recording()
  autocmd RecordingLeave * let g:vimline_last_reg = get(g:, 'vimline_rec_reg', '') | unlet g:vimline_rec_reg
  autocmd RecordingEnter,RecordingLeave * redrawstatus
augroup END
