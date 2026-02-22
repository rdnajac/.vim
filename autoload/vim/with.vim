" if using nvim, see `function vim._with(context, f)`
" `~/.local/neovim/share/nvim/runtime/lua/vim/_core/shared.lua:1515`

""
" Execute a command, leaving the cursor on the current line
function! vim#with#savedView(command)
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
function! vim#with#savedState(command)
  let current_histnr = histnr('/')
  call vim#with#savedView(a:command)
  if current_histnr != histnr('/')
    call histdel('/', -1)
    let @/ = histget('/', -1)
  endif
endfunction

""
" Execute a command with keeppatterns and optional default flags
" see `:h keeppatterns`
function! vim#with#patterns(command) abort
  " Optional second arg: default flags for :substitute
  execute 'keeppatterns' a:command . a:0 ? a:1 : ''
endfunction
