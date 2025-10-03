function! vimline#recording#() abort
  let rec = reg_recording()
  let reg = empty(rec) ? get(g:, 'vimline_last_reg', 'q') : rec
  let icon = empty(rec) ? '@' : '󰑋'
  let ret = '[' . icon . reg . '] '
  " if empty(rec)
  "   let macro = escape(keytrans(getreg(reg)), '%\|')
  "   return ret . macro . ' '
  " endif
  return ret
endfunction

if !exists('#RecordingEnter') || !exists('#RecordingLeave'))
  finish
endif

augroup vimline_recording
  autocmd!
  " Keep the recording component up to date
  autocmd RecordingEnter * let g:vimline_rec_reg = reg_recording()
  autocmd RecordingLeave * let g:vimline_last_reg = get(g:, 'vimline_rec_reg', '') | unlet g:vimline_rec_reg
  autocmd RecordingEnter,RecordingLeave * redrawstatus
augroup END
