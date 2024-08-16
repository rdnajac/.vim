command! -nargs=* VimuxRun call VimuxRun(<q-args>)
command! -bar VimuxRunLastCommand call VimuxRun(get(g:, 'VimuxLast', ''))
command! -nargs=? VimuxPrompt call VimuxRun(input('Vimux command: ', <q-args>))
command! Vimux call VimuxOpen()

function! VimuxOpen()
  if !exists('g:VimuxRunnerPaneId')
    let current_pane = system("tmux display -p '#{pane_id}'")
    call system('tmux split-window -p 20 -v')
    let g:VimuxRunnerPaneId = system("tmux display -p '#{pane_id}'")
    call system('tmux select-pane -t ' . current_pane)
  endif
endfunction

function! VimuxRun(command) abort
  call VimuxOpen()
  call system('tmux send-keys -t ' . g:VimuxRunnerPaneId . ' q C-u ' . shellescape(a:command) . ' Enter')
  let g:VimuxLast = a:command
endfunction

function! VimuxVisual() range abort
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if !empty(lines)
    let lines[-1] = lines[-1][:column_end - 1]
    let lines[0] = lines[0][column_start - 1:]
    call VimuxRun(join(lines, "\n"))
  endif
endfunction

function! VimuxCloseRunner()
  if exists('g:VimuxRunnerPaneId')
    call system('tmux kill-pane -t ' . g:VimuxRunnerPaneId)
    unlet g:VimuxRunnerPaneId
  endif
endfunction

autocmd VimLeave * call VimuxCloseRunner()

" Press <Enter> to send the selected text to Vimux
vnoremap <silent> <Enter> :call VimuxVisual()<CR>


" Set up file execution mapping for Python and shell scripts
autocmd FileType python,sh nnoremap <buffer> <silent> <localleader>ll :VimuxRun %<CR>
