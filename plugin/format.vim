function! Fmt()
    let winview = winsaveview()
    " now gq the whole thing
    normal! gggqG
    if v:shell_error > 0
	silent undo
	redraw
	echomsg 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
    endif
    call winrestview(winview)
endfunction
" nmap <silent> Q :let w:gqview = winsaveview()<CR>:set opfunc=Format<CR>g@"

augroup formatters
  autocmd!
  
  " use shellfmt and shellharden to format shell scripts
  autocmd FileType sh setlocal formatprg=shellharden\ --transform\ <(shfmt\ -bn\ -sr\ -fn\ %)
  " -i,  --indent uint       0 for tabs (default), >0 for number of spaces
  " -bn, --binary-next-line  binary ops like && and | may start a line
  " -sr, --space-redirects   redirect operators will be followed by a space
  " -fn, --func-next-line    function opening braces are placed on a separate line
  
  " use black to format python scripts
  autocmd FileType python setlocal formatprg=black\ --quiet\ -

  " use prettier for markdown and html files
  autocmd FileType markdown,html setlocal formatprg=prettier\ --stdin-filepath\ %

augroup END
