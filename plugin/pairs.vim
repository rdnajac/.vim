" autopairs
function! s:simple_auto_braces() abort
  inoremap {<Space> {}<Left>
  inoremap {<CR> {<CR>}<Esc>O
endfunction

" TODO: write a function to replace var with the opening and closing chars
" inoremap <buffer> ( ()<Left>
" inoremap <buffer> ' ''<Left>
" inoremap <buffer> {<SPACE> {}<LEFT><LEFT><SPACE><LEFT><SPACE>
" inoremap <buffer> {<CR> {<CR>}<C-c>O
" inoremap <buffer> {, {<CR>},<C-c>O

augroup vimrc_fold
  au!
  autocmd FileType json call s:simple_auto_braces()
  autocmd FileType lua call s:simple_auto_braces()
augroup END
