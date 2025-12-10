nnoremap cdb <Cmd>cd %:p:h<Bar>pwd<CR>
nnoremap cd- <Cmd>cd -<Bar>pwd<CR>
nnoremap cdp <Cmd>cd %:p:h:h<Bar>pwd<CR>

if !has('nvim')
  finish
endif
set nocdhome " default on neovim on unix, off on Windows or vim

let g:mydirs = {
      \ 'P': g:plug_home,
      \ 'c': g:stdpath.config,
      \ 'C': g:stdpath.cache,
      \ 'd': g:stdpath.data,
      \ 's': g:stdpath.state
      \ }

for [key, value] in items(g:mydirs)
  execute $'nnoremap cd{key} <Cmd>edit {value}<CR>'
endfor
