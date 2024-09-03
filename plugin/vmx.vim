let s:popup_options = {
      \ 'hidden': v:true,
      \ 'border': [1, 1, 1, 1],
      \ 'borderhighlight': ['String'],
      \ 'borderchars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
      \ 'line': (&lines - 2),
      \ 'close': 'click',
      \ }

function! s:popup(text)
    let popid = popup_create(a:text, s:popup_options)
    call popup_show(popid)
endfunction

function! RunFile() abort
    let cmd = './' . expand('%')
    let output = systemlist(cmd)
    call s:popup(join(output, "\n"))
endfunction

function! RunFileWithArgs(...) abort
    let cmd = './' . expand('%') . ' ' . join(a:000, ' ')
    let output = systemlist(cmd)
    call s:popup(join(output, "\n"))
endfunction

function! RunVisualSelectionAsShellCmd() abort
    let lines = getline("'<", "'>")
    let cmd = join(lines, "\n")
    let output = systemlist(cmd)
    call s:popup(join(output, "\n"))
endfunction

function! RunVisualSelectionAsVimScript() abort
    let lines = getline("'<", "'>")
    let vimscript_code = join(lines, "\n")
    let result = execute(vimscript_code)
    call s:popup(result)
endfunction

function! GetVimInfo() abort
    let line_num = line(".")
    let col_num = col(".")
    let syn_id = synIDtrans(synID(line_num, col_num, 1))
    let var1 = 'syntax: ' . synIDattr(syn_id, "name")
    let var2 = 'highlight group: ' . synIDattr(syn_id, "name")
    let var3 = 'line number: ' . line_num
    let var4 = 'column number: ' . col_num
    let var5 = 'cursor position: ' . line_num . ',' . col_num

    let output = [var1, var2, var3, var4, var5]
    for id in synstack(line_num, col_num)
        call add(output, 'highlight group: ' . synIDattr(id, "name"))
    endfor

    call s:popup(join(output, "\n"))
endfunction

command! RunFile call RunFile()
command! -nargs=* RunFileWithArgs call RunFileWithArgs(<f-args>)
command! RunVisualSelectionAsShellCmd call RunVisualSelectionAsShellCmd()
command! RunVisualSelectionAsVimScript call RunVisualSelectionAsVimScript()
command! GetVimInfo call GetVimInfo()

function! EXE(tmux_pane)
  " scp the current file to the remote server 
  " !scp % my-ec2:~/
  let cmd = '!scp % my-ec2:~/' 
  execute cmd
  let cmd = '!tmux send-keys -t ' . a:tmux_pane . ' "~/' . expand('$(basename %)') . '" Enter'
  execute cmd
endfunction
