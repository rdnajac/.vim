function! debug#buffer()
  verbose set buftype? bufhidden? buflisted? filetype? syntax?
endfunction

function! debug#fold()
  verbose set foldenable? foldmethod? foldexpr? foldlevel? foldlevelstart? foldminlines?
endfunction
