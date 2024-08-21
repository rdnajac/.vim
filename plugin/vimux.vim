" vim: ft=vim: fdm=marker
command! -nargs=* -complete=shellcmd VMX call s:vimux(<q-args>)


function! s:vimuxSendKeys(keys) abort
  call s:openRunner()
  call system('tmux send-keys -t ' . g:VimuxRunner . ' C-u')
  call system('tmux send-keys -t ' . g:VimuxRunner . ' ' . a:keys)
  call system('tmux send-keys -t ' . g:VimuxRunner . ' Enter')
  let g:VimuxLast = a:keys
endfunction

function! s:vimux(command) abort
  if !empty(a:command)
    call s:vimuxSendKeys(shellescape(a:command))
  elseif exists('g:VimuxLast')
    call s:vimuxSendKeys(g:VimuxLast)
  endif
endfunction

function! s:vimuxVisual() range abort
  " let lines = join(getline(a:firstline, a:lastline), "\r")
  " let escaped_lines = substitute(joined_lines, "'", "'\\\\''", 'g')
  let lines = 'hello() {\n echo "Hello, world!"\n}\nhello'
  call s:vimuxSendKeys(substitute(lines, '\n', '\r', 'g'))
endfunction


" Open the runner pane and capture its ID {{{
function! s:openRunner()
  if !exists('g:VimuxRunner')
    let g:VimuxRunner = substitute(system(
    \ 'tmux split-window -l 20% -P -F "#{pane_id}"'), '\n$', '', '')
    call system("tmux select-pane -t '{last}'")
  endif
endfunction
" }}} 

" Close the runner pane automatically on Vim exit {{{
function! s:closeRunner()
  if exists('g:VimuxRunner')
    call system('tmux kill-pane -t ' . g:VimuxRunner)
    unlet g:VimuxRunner
  endif
endfunction

augroup CloseRunner
  autocmd!
  autocmd VimLeave * call s:closeRunner()
augroup END
"}}}
