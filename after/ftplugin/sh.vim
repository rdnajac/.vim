" .vim/after/ftplugin/sh.vim
setlocal cindent shiftwidth=8 softtabstop=8 noexpandtab

" make . part of a word
setlocal iskeyword+=.

" start with a shebang!
nnoremap <localleader>b i#!/bin/bash<CR>#<CR>#<space>

" set includeexpr to expand env vars in includes
" let &l:includeexpr = "substitute(v:fname, '$\\%(::\\)\\=env(\\([^)]*\\))', '\\=expand(\"$\".submatch(1))', 'g')"

call apathy#Prepend('path', apathy#EnvSplit($PATH))
setlocal include=^\\s*\\%(\\.\\\|source\\)\\s
setlocal define=\\<\\%(\\i\\+\\s*()\\)\\@=
call apathy#Undo()


compiler shellcheck

set formatprg=shellharden\ --transform\ <(shfmt\ -bn\ -sr\ -fn\ %)
" shfmt --help
" -i,  --indent uint       0 for tabs (default), >0 for number of spaces
" -bn, --binary-next-line  binary ops like && and | may start a line
" -sr, --space-redirects   redirect operators will be followed by a space
" -fn, --func-next-line    function opening braces are placed on a separate line

