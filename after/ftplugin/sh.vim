setlocal cindent shiftwidth=8 softtabstop=8 noexpandtab

packadd! ultisnips

" turn off formatoption o
" setlocal formatoptions-=o

" Format shell scripts with shfmt:
"     Google-style indentation (two spaces)
"     -bn, --binary-next-line  binary ops like && and | may start a line
"     -ci, --case-indent       switch cases will be indented
"     -sr, --space-redirects   add spaces around redirects (e.g. >, >>, <, <<)
"     -fn, --function-next-line function opening brace may start a line
"     -kp, --keep-padding      (e.g. continued lines)
let b:ale_sh_shfmt_options = '-bn -fn'
" If you want Google-style indentation (two spaces) add `-i 2`

" Function to run shellharden on the buffer and replace the contents
function! Harden(buffer) abort
    let command = 'cat ' . a:buffer . " | shellharden --transform ''"
    return { 'command': command }
endfunction

" check if we have ALE before adding the fixer
execute ale#fix#registry#Add('shellharden', 'Harden', ['sh'], 'Double quote everything!')

let b:ale_fixers = ['shfmt', 'shellharden', 'remove_trailing_lines', 'trim_whitespace']
let b:ale_linters = ['shellcheck']
let b:format_on_save = 1

" call LspAddServer([#{name: 'bashls',
"                  \   filetype: 'sh',
"                  \   path: '/opt/homebrew/bin/bash-language-server',
"                  \   args: ['start']
"                  \ }])
