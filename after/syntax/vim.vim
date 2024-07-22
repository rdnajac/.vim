" after/syntax/vim.vim
" Ensure that # does not start comments in vimscript
syn match Error /^\s\=#.*$/ 
" wait! read this: https://github.com/vim/vim/issues/10967
" vim9 comments start with '#'...
