" .vim/after/ftplugin/sh.vim
setlocal cindent shiftwidth=8 softtabstop=8 noexpandtab

" when joining lines, delete the \ at the start of line
setlocal formatoptions+=j

" make . part of a word
setlocal iskeyword+=.

" start with a shebang!
nnoremap \b i#!/bin/bash<CR>#<CR>#<space>

" set includeexpr to expand env vars in includes
" let &l:includeexpr = "substitute(v:fname, '$\\%(::\\)\\=env(\\([^)]*\\))', '\\=expand(\"$\".submatch(1))', 'g')"

" from tpope/apathy {{{
call apathy#Prepend('path', apathy#EnvSplit($PATH))
setlocal include=^\\s*\\%(\\.\\\|source\\)\\s
setlocal define=\\<\\%(\\i\\+\\s*()\\)\\@=

call apathy#Undo()
" }}}


" lint
compiler shellcheck
augroup Shellcheck
  autocmd!
  " autocmd BufWritePost *.sh silent make! % | silent redraw!
  autocmd QuickFixCmdPost [^l]* cwindow
augroup END

let s:shfmt_options = '-bn -sr' 
" shft --help {{{
" -i,  --indent uint       0 for tabs (default), >0 for number of spaces
" -bn, --binary-next-line  binary ops like && and | may start a line
" -ci, --case-indent       switch cases will be indented
" -sr, --space-redirects   redirect operators will be followed by a space
" -kp, --keep-padding      keep column alignment paddings
" -fn, --func-next-line    function opening braces are placed on a separate line
"  }}}

" format shell scripts on save
function! s:format() abort
    let l:pos = getpos(".")
    let l:w = winsaveview()
    silent execute '%!shfmt ' . s:shfmt_options
    silent update
    silent execute '!shellharden --replace -- ' . shellescape(expand('%'))
    silent edit!
    call setpos('.', l:pos)
    call winrestview(l:w)
    redraw!
endfunction

augroup FormatOnSave
    autocmd!
    autocmd BufWritePre *.sh silent! call s:format()
augroup END


