" https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7


function! Redir(cmd, rng, start, end)
    call s:close_scratch_windows()
    if a:cmd =~ '^!'            " If command starts with '!', execute it in the shell
	let cmd = a:cmd =~' %'  " If command contains '%', escape the current file path
		    \ ? matchstr(substitute(a:cmd, ' %', ' ' . shellescape(escape(expand('%:p'), '\')), ''), '^!\zs.*')
		    \ : matchstr(a:cmd, '^!\zs.*')

	" Execute the shell command and capture the output
	if a:rng == 0
	    let output = systemlist(cmd)
	else
	    let joined_lines = join(getline(a:start, a:end), '\n')
	    let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
	    let output = systemlist(cmd . " <<< $" . cleaned_lines)
	endif
    else
	" If no '!', redirect Vim command output 
	redir => output
	execute a:cmd
	redir END
	let output = split(output, "\n")
    endif

    " Create a new scratch buffer and display the output
    let height = float2nr(&lines * 0.2)
    execute height . 'new'
    new
    let w:scratch = 1
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
    silent! nnoremap <silent> <buffer> q :<C-U>close<CR> 
    call setline(1, output)
endfunction

function s:close_scratch_windows() 
    for win in range(1, winnr('$'))
	if getwinvar(win, 'scratch')
	    execute win . 'windo close'
	endif
    endfor
endfunction

" This command definition includes -bar, so that it is possible to "chain" Vim commands.
" Side effect: double quotes can't be used in external commands
"command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

" This command definition doesn't include -bar, so that it is possible to use double quotes in external commands.
" Side effect: Vim commands can't be "chained".
command! -nargs=1 -complete=command -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)
