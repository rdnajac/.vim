" plugin/lint.vim
function! QF_signs() abort
  call sign_define('QFError',{'text':'💩'})
  call sign_unplace('*')
  let s:qfl = getqflist()
    for item in s:qfl
      call sign_place(0, '', 'QFError', item.bufnr, {'lnum': item.lnum})
    endfor
endfunction

augroup quickfix
  autocmd!
  autocmd FileType sh       compiler shellcheck
  autocmd FileType markdown compiler markdownlint
  " TODO: add compiler for markdownlint 
  autocmd QuickFixCmdPost [^l]* cwindow | silent! call QF_signs()
  autocmd QuickFixCmdPost   l*  lwindow | silent! call QF_signs()
augroup END

