" vim/autoload/run.vim
function! run#file() abort
    let cmd = './' . expand('%')
    let output = systemlist(cmd)
    call g:PopupShow(join(output, "\n"))
endfunction

function! run#file_with_args(...) abort
    let cmd = './' . expand('%') . ' ' . join(a:000, ' ')
    let output = systemlist(cmd)
    call g:PopupShow(join(output, "\n"))
endfunction

function! run#visual_selection_as_shell_cmd() abort
    let lines = getline("'<", "'>")
    let cmd = join(lines, "\n")
    let output = systemlist(cmd)
    call g:PopupShow(join(output, "\n"))
endfunction

function! run#visual_selection_as_vimscript() abort
    let lines = getline("'<", "'>")
    let vimscript_code = join(lines, "\n")
    let result = execute(vimscript_code)
    call g:PopupShow(result)
endfunction

function! run#in_tmux_pane(tmux_pane) abort
    let cmd = '!scp % my-ec2:~/' 
    execute cmd
    let cmd = '!tmux send-keys -t ' . a:tmux_pane . ' "~/' . expand('$(basename %)') . '" Enter'
    execute cmd
    call g:PopupNotify()
endfunction