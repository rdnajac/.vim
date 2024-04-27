function! GetInfo()
    let l:word = expand('<cword>')
    execute "tag " . l:word . " || help " . l:word . " || Man " . l:word . " || echo 'No info found for " . l:word . "'"
endfunction

nnoremap ? :call GetInfo()<CR>
