setlocal cindent shiftwidth=8 softtabstop=8 noexpandtab

" -i,  --indent uint       0 for tabs (default), >0 for number of spaces
" -bn, --binary-next-line  binary ops like && and | may start a line
" -ci, --case-indent       switch cases will be indented
" -sr, --space-redirects   redirect operators will be followed by a space
" -kp, --keep-padding      keep column alignment paddings
" -fn, --func-next-line    function opening braces are placed on a separate line
let b:ale_sh_shfmt_options = '-bn -sr'

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
compiler shellcheck
augroup Shellcheck
  autocmd!
  " autocmd BufWritePost *.sh silent make! % | silent redraw!
  autocmd QuickFixCmdPost [^l]* cwindow
augroup END

