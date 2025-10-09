" yank/delete everything
nnoremap yY <Cmd>%y<CR>
nnoremap dD <Cmd>%d<CR>

" delete/paste without yanking
nnoremap dy "_dd
vnoremap <leader>d "_d
" vnoremap <leader>p "_dP
vnoremap p "_dP

" yank path
nnoremap yp <Cmd>let @*=expand('%:p:~')<CR>
nnoremap yp <Cmd>let @*=expand('%:p:~') . ':' . line('.')<CR>

" https://github.com/mhinz/vim-galore?tab=readme-ov-file#quickly-edit-your-macros
" nnoremap <leader>cm :<C-u><C-r><C-r>="let @". v:register ." = ". string(getreg(v:register))<CR><Left>
" just edit q
nnoremap <leader>2 :<C-u><C-r><C-r>="let @q = " . string(getreg('q'))<CR>
nnoremap <leader>3 <Cmd><C-r><C-r>="let @q = " . string(getreg('q'))<CR>

let s:skip = v:true

function! s:yankring() abort
  if v:event.operator !=# 'y'
    return
  endif
  "
  " if s:skip
  "   let s:skip = v:false
  "   return
  " endif
  "
  for i in range(9, 1, -1)
    call setreg(string(i), getreg(string(i - 1)))
  endfor
endfunction

augroup vimrc_yank
  autocmd!
  autocmd TextYankPost * call s:yankring()
  if !has('nvim')
    packadd hlyank
  else
    autocmd TextYankPost * silent! lua vim.hl.on_yank()
  endif
augroup END

