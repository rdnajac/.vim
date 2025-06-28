scriptencoding=utf-8
" https://stackoverflow.com/a/28399202/26469286
" For files that don't have filetype-specific syntax rules
" autocmd BufNewFile,BufRead *syntax match NotPrintableAscii "[^\x20-\x7F]"
" For files that do have filetype-specific syntax rules
" autocmd Syntax * syntax match NotPrintableAscii "[^\x20-\x7F]" containedin=ALL
" hi NotPrintableAscii ctermbg=236

highlight Evil guifg=red guibg=orange

augroup syntax
  autocmd BufNewFile,BufRead * syntax match Evil /“\|”/
  autocmd Syntax * syntax match Evil /“\|”/
  " highlight error for vim scripts
  autocmd BufReadPost,BufNewFile *.vim  if search('vim9script', 'nw') == 0 | syn match Error /^\s*#.*$/ | endif
augroup End



highlight CommentStringInBackticks guibg=NONE guifg=#39ff14
syntax region CommentStringInBackticks start=/`/ end=/`/ contained containedin=.*Comment
