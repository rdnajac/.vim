" E841: Reserved name, cannot be used for user defined command
command! -nargs=+ A call append('$', XHandler(<f-args>))

function! XHandler(...) abort
  let args = a:000
  if args[0] == '!'
    let cmd = join(args[1:], ' ')
    return split(system(cmd), "\n")
  else
    return split(execute(join(args, ' ')), "\n")
  endif
endfunction
