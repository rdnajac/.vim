function! vim#toggle#register_keymaps() abort
  nnoremap yol :set list!<BAR>set list?<CR>
  nnoremap yon :set number!<BAR>redraw!<BAR>set number?<CR>
  nnoremap yos :set spell!<BAR>set spell?<CR>
  nnoremap yow :set wrap!<BAR>set wrap?<CR>
  nnoremap yo~ :set autochdir!<BAR>set autochdir?<CR>
endfunction
