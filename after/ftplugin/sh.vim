" .vim/after/ftplugin/sh.vim
setlocal cindent shiftwidth=8 softtabstop=8 noexpandtab

" start with a shebang!
nnoremap \b i#!/bin/bash<CR>#<CR>#<space>

" set includeexpr to expand env vars in includes
let &l:includeexpr = "substitute(v:fname, '$\\%(::\\)\\=env(\\([^)]*\\))', '\\=expand(\"$\".submatch(1))', 'g')"

" vanilla linting
compiler shellcheck
augroup Shellcheck
  autocmd!
  " autocmd BufWritePost *.sh silent make! % | silent redraw!
  autocmd QuickFixCmdPost [^l]* cwindow
augroup END

let s:shfmt_options = '-bn -sr' " {{{
" -i,  --indent uint       0 for tabs (default), >0 for number of spaces
" -bn, --binary-next-line  binary ops like && and | may start a line
" -ci, --case-indent       switch cases will be indented
" -sr, --space-redirects   redirect operators will be followed by a space
" -kp, --keep-padding      keep column alignment paddings
" -fn, --func-next-line    function opening braces are placed on a separate line
"  }}}

if exists('g:loaded_ale')
    let b:ale_sh_shfmt_options = s:shfmt_options

    " Add shellharden as a fixer
    function! ShellHarden(buffer) abort
	let command = 'cat ' . a:buffer . " | shellharden --transform ''"
	return { 'command': command }
    endfunction
    execute ale#fix#registry#Add('shellharden', 'ShellHarden', ['sh'], 'Double quote everything!')

    " don't format on save for bashrc, bash_aliases, etc
    if expand('%:t') =~? '^\(\.\?bash\(rc\|_aliases\|_profile\|_login\|_logout\|_history\)\|\.profile\)$'
	let b:ale_fix_on_save = 0
    else
	let b:ale_fix_on_save = 1
    endif

endif 
