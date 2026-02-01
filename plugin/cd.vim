" FIXME: !!!
nnoremap cdb <Cmd>cd %:p:h<Bar>pwd<CR>
nnoremap cd- <Cmd>cd -<Bar>pwd<CR>
nnoremap cdp <Cmd>cd %:p:h:h<Bar>pwd<CR>

if !has('nvim')
  finish
endif
set nocdhome " default on neovim on unix, off on Windows or vim

" TODO: make line continuations in vim act like a bulleted list
let s:dirs = {
      \ '.': g:chezmoi#source_dir_path,
      \ '~': $HOME,
      \ 'G': $HOME.'/GitHub/',
      \ 'p': g:plug_home,
      \ 'v': g:['vimrc#dir'],
      \ 'V': $VIMRUNTIME,
      \ }

if exists('g:plug_home')
  let s:dirs.P = g:plug_home
endif

if exists('g:stdpath')
  let s:dirs.c = stdpath('config')
  let s:dirs.C = stdpath('cache')
  let s:dirs.d = stdpath('data')
  let s:dirs.s = stdpath('state')
endif

for [key, value] in items(s:dirs)
  execute $'nnoremap cd{key} <Cmd>edit {value}<CR>'
  " FIXME: if explorer is already open this should behave differently
endfor
