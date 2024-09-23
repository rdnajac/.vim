augroup quickfix
  autocmd!
  autocmd FileType sh       compiler shellcheck
  autocmd FileType markdown compiler markdownlint
  " TODO: add compiler for markdownlint 
  autocmd QuickFixCmdPost [^l]* cwindow | silent! call QF_signs()
  autocmd QuickFixCmdPost   l*  lwindow | silent! call QF_signs()
augroup END
