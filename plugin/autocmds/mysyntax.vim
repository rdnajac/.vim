scriptencoding utf-8
" https://stackoverflow.com/a/28399202/26469286
" For files that don't have filetype-specific syntax rules
" autocmd BufNewFile,BufRead *syntax match NotPrintableAscii "[^\x20-\x7F]"
" For files that do have filetype-specific syntax rules
" autocmd Syntax * syntax match NotPrintableAscii "[^\x20-\x7F]" containedin=ALL
" hi NotPrintableAscii ctermbg=236

highlight Evil guifg=red guibg=orange

augroup mySyntax
  autocmd!

  " Global Syntax Settings
  autocmd BufNewFile,BufRead * syntax match Evil /“\|”/
  autocmd Syntax * syntax match Evil /“\|”/

  " Highlight Strings in Comments
  autocmd Syntax * syntax region CommentBacktickString start=/`/ end=/`/ contained containedin=.*Comment
  autocmd Syntax * highlight link CommentBacktickString String

  " Vim Highlight Error for Vim Scripts
  autocmd BufReadPost,BufNewFile *.vim  if search('vim9script', 'nw') == 0 | syn match Error /^\s*#.*$/ | endif

  " Fix Syntax Highlighting for Specific Filetypes
  autocmd BufNewFile,BufRead *.html set filetype=html
  autocmd BufNewFile,BufRead bash_aliases set filetype=sh
  autocmd BufNewFile,BufRead gitconfig set filetype=gitconfig

augroup END
