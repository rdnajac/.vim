command! -nargs=+ DiffBufs
      \ call execute('buffer ' . split(<q-args>)[0]) |
      \ call execute('vert sbuffer ' . split(<q-args>)[1]) |
      \ diffthis |
      \ wincmd p |
      \ diffthis

if exists(':DiffOrig') != 2
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
	\ | diffthis | wincmd p | diffthis
endif
