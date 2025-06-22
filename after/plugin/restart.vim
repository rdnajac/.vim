if has('nvim')
  augroup restoresession
    autocmd!
    autocmd VimEnter * if filereadable(v:this_session) |
	  \ execute 'source ' . v:this_session | call delete(v:this_session) |
	  \ if filereadable(expand('%')) |
	  \   call timer_start(1, { -> execute('edit') }) |
	  \ endif |
	  \ endif
  augroup END

  command! Restart mksession! | restart
  command! Ree Restart
endif
