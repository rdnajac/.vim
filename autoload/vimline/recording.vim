function! vimline#recording#() abort
  let rec = reg_recording()
  if empty(rec) && !exists('g:vimline_last_reg')
    return ''
  endif

  let reg = empty(rec) ? g:vimline_last_reg : rec
  let icon = empty(rec) ? '@' : '󰑋'

  " Get and sanitize register contents
  let contents = getreg(reg)
  let safe = escape(contents, '%\|')
  let preview = substitute(keytrans(safe), ' ', '<SPACE>', 'g')
  let preview = substitute(preview, '<Up>', '', 'g')
  let preview = substitute(preview, '<Up>', '', 'g')

  return printf('%s [%s%s] ', preview, icon, reg)
endfunction

if exists('##RecordingEnter') && exists('##RecordingLeave')
  augroup vimline_recording
    autocmd!
    autocmd RecordingEnter *
	  \ let reg = reg_recording() |
	  \ if !exists('g:vimline_has_recorded') |
	  \   call setreg(reg, '') |
	  \   let g:vimline_has_recorded = 1 |
	  \ endif |
	  \ let g:vimline_rec_reg = reg
    autocmd RecordingLeave *
	  \ let g:vimline_last_reg = get(g:, 'vimline_rec_reg', '') |
	  \ unlet g:vimline_rec_reg
    autocmd RecordingEnter,RecordingLeave * redrawstatus
  augroup END
endif
