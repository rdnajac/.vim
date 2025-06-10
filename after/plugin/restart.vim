if has('nvim')
  let s:sesh = fnameescape(fnamemodify($MYVIMRC, ':h') . '/session.vim')

  command! Restart execute 'mksession! ' . s:sesh | restart

  augroup RestoreSession
    autocmd!
    autocmd VimEnter * if filereadable(s:sesh) |
	  \ execute 'source ' . s:sesh |
	  \ if filereadable(expand('%')) |
	  \   call timer_start(1, { -> execute('edit') }) |
	  \ endif |
	  \ call delete(s:sesh) |
	  \ endif
  augroup END

endif
