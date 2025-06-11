if has('nvim')
  let s:sesh = fnameescape(fnamemodify($MYVIMRC, ':h') . '/Session.vim')

  augroup RestoreSession
    autocmd!
    autocmd VimEnter * if filereadable(s:sesh) |
	  \ execute 'source ' . s:sesh | call delete(s:sesh) |
	  \ if filereadable(expand('%')) |
	  \   call timer_start(1, { -> execute('edit') }) |
	  \ endif |
	  \ endif
  augroup END

  command! Restart execute 'mksession! ' . s:sesh | restart
endif
