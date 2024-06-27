function! CheckHighlightGroup() abort
  return synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
endfunction
nnoremap <silent> <leader>hi :echo CheckHighlightGroup()<CR>
