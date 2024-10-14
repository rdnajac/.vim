scriptencoding utf-8
" https://stackoverflow.com/a/28399202/26469286
" For files that don't have filetype-specific syntax rules
" autocmd BufNewFile,BufRead *syntax match NotPrintableAscii "[^\x20-\x7F]"
" For files that do have filetype-specific syntax rules
" autocmd Syntax * syntax match NotPrintableAscii "[^\x20-\x7F]" containedin=ALL
" hi NotPrintableAscii ctermbg=236

" wrap it in an augroup to avoid errors when sourcing the file multiple times
highlight Evil guifg=red guibg=orange
augroup GlobalSyntaxSettings
	autocmd!
	autocmd BufNewFile,BufRead *syntax match Evil /“\|”/
	autocmd Syntax * syntax match Evil /“\|”/
augroup END

augroup HighlightStringsInComments
    autocmd!
    autocmd Syntax * syntax region CommentBacktickString start=/`/ end=/`/ contained containedin=.*Comment
    autocmd Syntax * highlight link CommentBacktickString String
augroup END

augroup VimHighlightError
  autocmd!
  autocmd BufReadPost,BufNewFile *.vim  if search('vim9script', 'nw') == 0 | syn match Error /^\s*#.*$/ | endif
augroup END
