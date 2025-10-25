function! vim#on_enter#(fn) abort
  if v:vim_did_enter
    call call(a:fn, [])
  else
    execute 'autocmd VimEnter * call ' . string(a:fn) . '()'
  endif
endfunction

