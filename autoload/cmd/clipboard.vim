" create an ephemeral buffer containing the clipboard contents
" on write, yank the buffer contents to the clipboard and delete the buffer
function! cmd#clipboard#() abort
  edit +setl\ bt=acwrite\ bh=wipe\ nobl\ noswf Clipboard
  silent execute 'put +|1d _'
  autocmd BufWriteCmd <buffer> %yank + | set nomodified'
endfunction
