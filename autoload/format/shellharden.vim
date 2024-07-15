function! format#shellharden#replace() abort
  let file = expand('%:p')
  let cmd = 'shellharden --replace ' . shellescape(file)
  execute 'silent !' . cmd

  " Reload the buffer to reflect changes
  if v:shell_error == 0
    edit!
    redraw!
  else
    echoerr "Error formatting shell script: " . file
  endif
endfunction
