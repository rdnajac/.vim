" the main function that will run the command 
" and display the output in a popup window
function! Run(cmd) abort
  let output = systemlist(a:cmd)
  call popup_notification(output, {})
endfunction

" sanitize the input and call the main function
function! RunLines(lines, ...) abort
	let cleaned_lines = 
	      \ substitute(shellescape(a:lines), "'\\\\''", "\\\\'", 'g')
	call Run(cmd)
endfunction

function RunUntilThisLine() 
  let l:lines = getline(1, line('.'))
	call RunLines(l:lines)
endfunction
