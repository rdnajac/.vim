function! s:diffthese() abort
  diffthis | wincmd p |diffthis
endfunction

command! -nargs=+ DiffBufs
      \ call execute('buffer ' . split(<q-args>)[0]) |
      \ call execute('vert sbuffer ' . split(<q-args>)[1]) |
      \ call s:diffthese()

if exists(':DiffOrig') != 2
  command DiffOrig
	\ vert new | set bt=nofile | r ++edit # | 0d_ |
	\ call s:diffthese()
endif
