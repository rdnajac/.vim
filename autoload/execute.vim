" see `:h keepjumps`
" see `:h keeppatterns`

""
" Execute a command, leaving the cursor on the current line
function! execute#inPlace(command)
  let saved_view = winsaveview()
  execute a:command
  call winrestview(saved_view)
endfunction

""
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

""
" Execute a command with keeppatterns and optional default flags
function! execute#s(command) abort
  " Optional second arg: default flags for :substitute
  execute 'keeppatterns' a:command . a:0 ? a:1 : ''
endfunction

