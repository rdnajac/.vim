function! ui#qf#signs() abort
  call sign_define('QFError',{'text':'💩'})
  call sign_unplace('*')
  let s:qfl = getqflist()
  for item in s:qfl
    call sign_place(0, '', 'QFError', item.bufnr, {'lnum': item.lnum})
  endfor
endfunction

" copy these to your .vimrc...
" autocmd QuickFixCmdPost [^l]* cwindow | silent! call s:qf_signs()
" autocmd QuickFixCmdPost   l*  lwindow | silent! call s:qf_signs()
