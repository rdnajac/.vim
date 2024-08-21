" get info about the current cursor position
" aggregate it and send it to a popup window
function GetHi()
  let var1 = 'syntax: ' . synIDattr(synIDtrans(synID(line("."), col("."), 1)), "name")
  let output = [var1]
  for id in synstack(line("."), col("."))
    call add(output, 'highlight group: ' . synIDattr(id, "name"))
  endfor
  return join(output, "\n")
endfunction

function GetInfo()
  let info = GetHi()
  call Popup('info', split(info, "\n"))
endfunction

" Execute the current file and display the output in a popup window
function! VX(...)
  " Build the command from the file and arguments
  let cmd = './' . expand('%') . ' ' . join(a:000, ' ')
  " Call Popup with the command output
  call Popup(systemlist(cmd))
endfunction
command! -nargs=* VX call VX(<f-args>)

" the main function that will run the command 
" and display the output in a popup window
function! Run(cmd) abort
  let output = systemlist(a:cmd)
  call popup_notification(output, {})
endfunction

" sanitize the input and call the main function
function! RunLines(lines, ...) abort
	let cleaned_lines = substitute(shellescape(a:lines), "'\\\\''", "\\\\'", 'g')
	call Run(cmd)
endfunction

function RunUntilThisLine() 
  let l:lines = getline(1, line('.'))
	call RunLines(l:lines)
endfunction

function! Redir(cmd, rng, start, end)
	for win in range(1, winnr('$'))
		if getwinvar(win, 'scratch')
			execute win . 'windo close'
	endif
	endfor
	if a:cmd =~ '^!'
		let cmd = a:cmd =~' %'
			\ ? matchstr(substitute(a:cmd, ' %', ' ' . shellescape(escape(expand('%:p'), '\')), ''), '^!\zs.*')
			\ : matchstr(a:cmd, '^!\zs.*')
		if a:rng == 0
			let output = systemlist(cmd)
		else
			let joined_lines = join(getline(a:start, a:end), '\n')
			let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
			let output = systemlist(cmd . " <<< $" . cleaned_lines)
		endif
	else
		redir => output
		execute a:cmd
		redir END
		let output = split(output, "\n")
	endif
	vnew
	let w:scratch = 1
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
	call setline(1, output)
endfunction

" This command definition includes -bar, so that it is possible to "chain" Vim commands.
" Side effect: double quotes can't be used in external commands
command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

" This command definition doesn't include -bar, so that it is possible to use double quotes in external commands.
" Side effect: Vim commands can't be "chained".
command! -nargs=1 -complete=command -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)
