function! vim#debug#buffer()
  verbose set buftype? bufhidden? buflisted? filetype? syntax?
endfunction

function! vim#debug#fold()
  verbose set foldenable? foldmethod? foldexpr? foldlevel? foldlevelstart? foldminlines?
endfunction

function! vim#debug#shell()
  verbose set shell? shellcmdflag? shellpipe? shellquote? shellredir? shellslash? shellxquote?
endfunction
