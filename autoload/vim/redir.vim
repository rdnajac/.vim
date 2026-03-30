" https://github.com/romainl/vim-redir
" redirect the output of a Vim command into a scratch buffer
function! redir#Redir(cmd = '', rng = 0, start = 1, end = 1, bang = '')
  " get a clean command, without ^M at the end
  let cmd = a:cmd->trim()

  " close existing scratch windows
  for win in range(1, winnr('$'))
    if getwinvar(win, 'scratch')
      execute win . 'windo close'
    endif
  endfor

  " if called via :Redir!, assume the user wants to repeat the last Ex
  " command
  if a:bang == '!' && cmd->empty()
    let cmd = expand(@:)->trim()
  endif

  " if cmd starts with !, assume it is an external command
  if cmd =~ '^!'
    let ext_cmd = cmd =~' %'
	  \ ? matchstr(substitute(cmd, ' %', ' ' . shellescape(escape(expand('%:p'), '\')), ''), '^!\zs.*')
	  \ : matchstr(cmd, '^!\zs.*')
    if a:rng == 0
      let output = systemlist(ext_cmd)
    else
      let joined_lines = join(getline(a:start, a:end), '\n')
      let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
      let output = systemlist(ext_cmd . " <<< $" . cleaned_lines)
    endif
    " if not, assume it is a Vim command
  else
    redir => output
    execute cmd
    redir END
    let output = split(output, "\n")
  endif

  " open a new window
  vnew

  " flag it as a scratch window
  let w:scratch = 1

  " make it a scratch window
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile

  " fill the buffer with the output of the given command
  call setline(1, output)
endfunction

" redirect the output of a Vim or external command into a scratch buffer
" command! -nargs=? -complete=command -bar -range -bang Redir silent call redir#Redir(<q-args>, <range>, <line1>, <line2>, '<bang>')
