setlocal cindent shiftwidth=8 softtabstop=8 noexpandtab
let &l:includeexpr = "substitute(v:fname, '$\\%(::\\)\\=env(\\([^)]*\\))', '\\=expand(\"$\".submatch(1))', 'g')"
" set includeexpr=l:includeexpr

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

compiler shellcheck
augroup Shellcheck
  autocmd!
  " autocmd BufWritePost *.sh silent make! % | silent redraw!
  autocmd QuickFixCmdPost [^l]* cwindow
augroup END

" Add shellharden as a fixer
function! ShellHarden(buffer) abort
  let command = 'cat ' . a:buffer . " | shellharden --transform ''"
  return { 'command': command }
endfunction

" if g:loaded_ale =1 add, otherwise nah
if exists('g:loaded_ale')
  execute ale#fix#registry#Add('shellharden', 'ShellHarden', ['sh'], 'Double quote everything!')
endif 
