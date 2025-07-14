" vim/autoload/redirect.vim
function! s:close_scratch_wins() abort
  for win in range(1, winnr('$'))
    if getwinvar(win, 'scratch')
      " execute win . 'windo close'
      execute win . 'close'
    endif
  endfor
endfunction

function! s:to_scratch(output) abort
  vnew
  let w:scratch = 1
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  call setline(1, a:output)
endfunction

" https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
function! redir#original(cmd, rng, start, end) abort
  s:close_scratch_wins()
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
  call s:to_scratch(output)
endfunction

function! redir#prompt() abort
  let input = input('$ ')
  " handle `%` filename expansion
  let cmd = expand(input)
  if !empty(cmd)
    call s:to_scratch(split(system(input), "\n"))
  endif
endfunction

function! redir#execute(command) abort
  call s:close_scratch_wins()
  let output = split(execute(a:command, 'silent'), "\n")
  call s:to_scratch(output)
endfunction

" This command definition includes -bar, so that it is possible to "chain" Vim commands.
" Side effect: double quotes can't be used in external commands
" command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

" This command definition doesn't include -bar, so that it is possible to use double quotes in external commands.
" Side effect: Vim commands can't be "chained".
" command! -nargs=1 -complete=command -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)
