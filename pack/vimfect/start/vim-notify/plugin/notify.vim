" open file in a new window when or jump to line number when appropriate
" nnoremap <expr> gf &ft =~# '\vmsg\|pager' ? ''
" \ : expand('<cWORD>') =~# ':\d\+$' ? 'gF' : 'gf'
for level in keys(g:vim#notify#levels)
  execute printf('command! -nargs=1 -complete=expression %s call vim#notify#%s(eval(<q-args>))',
	\ toupper(strpart(level, 0, 1)) . strpart(level, 1), level)
endfor
