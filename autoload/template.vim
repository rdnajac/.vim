function! template#read(fname)
  let template = stdpath('config') .. '/templates/' .. a:fname
  if filereadable(template)
    execute '0r ' .. fnameescape(template)
  endif
endfunction
