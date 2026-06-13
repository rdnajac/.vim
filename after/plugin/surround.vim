" plugin/surround.vim
" http://howivim.com/2016/andrew-radev/
" nmap dsf F(bdt(ds(
nnoremap <silent> dsf <Cmd>call dsf#delete_surrounding_functioncall()<CR>

if !exists('g:loaded_surround') 
  finish
endif

" toggle (change) 'single' or "double" quotes
nmap cq <Cmd>call vim#with#savedView("normal cs\"'")<CR>
nmap cQ <Cmd>call vim#with#savedView("normal cs'\"")<CR>

nmap S viWS
xmap ` S`
xmap F Sf


" nmap dsf dSf

" nmap ys sa
" nmap ds sd
" nmap cs sr
" nmap yss ys_
