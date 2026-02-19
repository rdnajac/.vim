function! fn#now#() abort
  let total = reltimefloat(reltime())
  let totalsec = float2nr(total)
  let ms = float2nr((total - totalsec) * 1000)
  return strftime("%H:%M:%S", totalsec) . printf(".%03d", ms)
endfunction
"
" ia <expr> dt strftime('%Y-%m-%d')
" ia <expr> tm strftime('%H:%M:%S')
" ia <expr> dtm strftime('%Y-%m-%d %H:%M:%S')
" ia LR LAST REVISION: <C-R>=strftime('%Y-%m-%d')<CR>
