setlocal et ts=2 sw=2 nowrap fdm=marker

nnoremap <leader>bs i#!/bin/bash/<ESC>o<ESC>ofunction main(){<ESC>o<ESC>o}<ESC>ki<S-TAB>
nnoremap <leaderex :!chmod +x % && ./%<CR>
nnoremap <leader>sh :!chmod +x % && source %

" Format shell scripts with shfmt:
"     Google-style indentation (two spaces)
"     -bn, --binary-next-line  binary ops like && and | may start a line
"     -ci, --case-indent       switch cases will be indented
let b:ale_sh_shfmt_options = '-i 2 -bn-sr'

" Function to run shellharden on the buffer and replace the contents
function! Harden(buffer) abort
    let command = 'cat ' . a:buffer . " | shellharden --transform ''"
    return { 'command': command }
endfunction
execute ale#fix#registry#Add('shellharden', 'Harden', ['sh'], 'Double quote everything!')

let b:ale_fixers = ['shfmt', 'shellharden', 'remove_trailing_lines', 'trim_whitespace']
let b:ale_linters = ['shellcheck', 'cspell']
let b:format_on_save = 1
