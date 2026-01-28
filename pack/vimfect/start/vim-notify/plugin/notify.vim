" open file in a new window when or jump to line number when appropriate
" nnoremap <expr> gf &ft =~# '\vmsg\|pager' ? ''
" \ : expand('<cWORD>') =~# ':\d\+$' ? 'gF' : 'gf'

