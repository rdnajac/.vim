setlocal cindent shiftwidth=8 softtabstop=8 noexpandtab
" setlocal formatoptions-=o

let b:ale_linters = ['shellcheck']

" Format shell scripts with shfmt:
"     -bn, --binary-next-line  binary ops like && and | may start a line
"     -fn, --function-next-line function opening brace may start a line
let b:ale_sh_shfmt_options = '-bn -fn'
let b:ale_fixers = ['shfmt', 'shellharden', 'remove_trailing_lines', 'trim_whitespace']
" only format if we're not editing a special file

if expand('%:t') =~? '^\(\.\?bash\(rc\|_aliases\|_profile\|_login\|_logout\|_history\)\|\.profile\)$'
  let b:ale_fix_on_save = 0
else
  let b:ale_fix_on_save = 1
endif


" call LspAddServer([#{name: 'bashls',
"                  \   filetype: 'sh',
"                  \   path: '/opt/homebrew/bin/bash-language-server',
"                  \   args: ['start']
"                  \ }])
"
