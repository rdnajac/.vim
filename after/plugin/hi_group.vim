function! HighlightGroup()
    let l:word = expand('<cword>')
    let l:highlight_group = synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
    return l:highlight_group
endfunction
nnoremap <silent> <leader>hi :echo HighlightGroup()<CR>
