""
" Turn the current buffer into a scratch buffer.
" Optional dict arg overrides 'buftype' (default 'nofile'), e.g.
" `vim#scratch#({'buftype': 'acwrite'})` for buffers with a BufWriteCmd.
function! vim#scratch#(...) abort
  let opts = a:0 ? a:1 : {}
  let &l:buftype = get(opts, 'buftype', 'nofile')
  setlocal bufhidden=wipe nobuflisted noswapfile
endfunction
