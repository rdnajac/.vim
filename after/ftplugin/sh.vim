setlocal define=\\<\\%(\\i\\+\\s*()\\)\\@=
setlocal include=^\\s*\\%(\\.\\\|source\\)\\s
call vim#apathy#('path', split($PATH,':'))

setlocal formatoptions-=o

" let s:shfmt_flags = '-bn -sr'
" if executable('shfmt')
"   let s:cmd = join(['shfmt', s:shfmt_flags, '--simplify'], ' ')
"   if executable('shellharden')
"     let s:cmd = 'shellharden --transform "" | ' . s:cmd
"   endif
"   let &l:formatprg = s:cmd
" endif
"
" let b:ale_sh_shfmt_options = s:shfmt_flags
" function! ShellHarden(buffer) abort
"   let command = 'cat ' . a:buffer . " | shellharden --transform ''"
"   return { 'command': command }
" endfunction
" execute ale#fix#registry#Add('shellharden', 'ShellHarden', ['sh'], 'Double quote everything!')
