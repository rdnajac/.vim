set formatexpr=format#expr()

function! GQ(type, ...)
  normal! '[v']gq
  call winrestview(w:gqview)
  unlet w:gqview
endfunction
nmap <silent> gq :let w:gqview = winsaveview()<CR>:set opfunc=GQ<CR>g@

augroup AutoFormat
  autocmd!
  autocmd BufWritePre *.lua,*.sh,*.vim if &modified | silent call format#buffer() | endif
augroup END
