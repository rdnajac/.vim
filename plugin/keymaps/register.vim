" yank/delete everything
nnoremap yY <Cmd>%y<CR>
nnoremap dD <Cmd>%d<CR>

" delete/paste without yanking
nnoremap dy "_dd
vnoremap <leader>d "_d
vnoremap <leader>p "_dP

" yank path
nnoremap yp <Cmd>let @*=expand('%:p:~')<CR>
nnoremap yp <Cmd>let @*=expand('%:p:~') . ':' . line('.')<CR>

" https://github.com/mhinz/vim-galore?tab=readme-ov-file#quickly-edit-your-macros
" nnoremap <leader>cm :<C-u><C-r><C-r>="let @". v:register ." = ". string(getreg(v:register))<CR><Left>
" just edit q
nnoremap <leader>cm :<C-u><C-r><C-r>="let @q = " . string(getreg('q'))<CR><Left>
