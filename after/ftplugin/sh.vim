setlocal et ts=2 sw=2
setlocal nowrap nospell
setlocal foldmethod=marker

nnoremap bs i#!/bin/bash/<ESC>o<ESC>ofunction main(){<ESC>o<ESC>o}<ESC>ki<S-TAB>
nnoremap ex :!chmod +x % && ./%<CR>
nnoremap sh :!chmod +x % && source %

let g:BASH_CustomTemplateFile = $HOME . '/.vim/templates/bash.template'
call mmtemplates#config#Add ( 'bash', '<PATH>/some.templates', 'example', 'nte' )
