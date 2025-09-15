function! scp#(dest) abort
  if !executable('scp')
    echoerr 'scp command not found'
    return
  endif

  if a:dest == ''
    echoerr 'Usage: :Scp user@host[:/remote/path]'
    return
  endif

  let target = a:dest =~ ':' ? a:dest : a:dest . ':~/'
  write
  execute '!scp % ' . shellescape(target)
endfunction

function! scp#complete(A, L, P) abort
  let all = split(system("grep '^Host\\>' ~/.ssh/config | awk '{print $2}'"), "\n")
  return filter(all, 'v:val =~? "^" . a:A')
endfunction
