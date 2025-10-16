function! vim#auto#braces() abort
  inoremap <buffer> {<Space> {}<Left>
  inoremap <buffer> {<CR> {<CR>}<Esc>O
endfunction

" TODO: write a function to replace var with the opening and closing chars
" inoremap <buffer> ( ()<Left>
" inoremap <buffer> ' ''<Left>
" inoremap <buffer> {<SPACE> {}<LEFT><LEFT><SPACE><LEFT><SPACE>
" inoremap <buffer> {<CR> {<CR>}<C-c>O
" inoremap <buffer> {, {<CR>},<C-c>O
