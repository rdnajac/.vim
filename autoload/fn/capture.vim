function! capture#text() abort
  if mode() ==# 'n'
    return getline('.') . "\n"
  endif

  let save_z = @z
  silent normal! gv"zy
  let text = @z
  let @z = save_z

  return text =~ '\n$' ? text : text . "\n"
endfunction

function! capture#input(ranged, l1, l2, cmd) abort
  if mode() ==# 'n'
    if a:ranged
      return [a:cmd, join(getline(a:l1, a:l2), "\n") . "\n"]
    endif
    return [a:cmd]
  endif
  return [a:cmd, CaptureText()]
endfunction
