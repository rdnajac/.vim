
ia p3 #!/usr/bin/env python3<CR>


function BinBash() abort
  if line('$') == 1 && getline(1) == ''
    call setline(1, '#!/bin/bash')
    normal! o
    write
    edit
    normal! 2G
    startinsert
  else
    echo "File is not empty."
  endif
endfunction

nnoremap <leader>bb :call BinBash()<CR>


