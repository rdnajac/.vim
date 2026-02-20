""
" Execute a command, leaving the cursor on the current line
function! execute#inPlace(command)
  try
    let view = winsaveview()
    execute a:command
  finally
    call winrestview(view)
  endtry
endfunction

""
" Execute a command, leaving the cursor on the current line and avoiding
" clobbering the search register.
" see `:h keepjumps`
function! execute#withSavedState(command)
  let current_histnr = histnr('/')
  call execute#inPlace(a:command)
  if current_histnr != histnr('/')
    call histdel('/', -1)
    let @/ = histget('/', -1)
  endif
endfunction

""
" Execute a command with keeppatterns and optional default flags
" see `:h keeppatterns`
function! execute#s(command) abort
  " Optional second arg: default flags for :substitute
  execute 'keeppatterns' a:command . a:0 ? a:1 : ''
endfunction
