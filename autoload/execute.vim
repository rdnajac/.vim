" Execute a command, leaving the cursor on the current line
function! execute#inPlace(command)
  let saved_view = winsaveview()
  exe a:command
  call winrestview(saved_view)
endfunction

" Execute a command, leaving the cursor on the current line and avoiding
" clobbering the search register.
function! execute#withSavedState(command)
  let current_histnr = histnr('/')

  call execute#inPlace(a:command)

  if current_histnr != histnr('/')
    call histdel('/', -1)
    let @/ = histget('/', -1)
  endif
endfunction