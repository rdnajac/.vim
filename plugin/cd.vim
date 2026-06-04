let s:dirs = {
      \ '~': $HOME,
      \ 'B': &backupdir,
      \ 'c': g:stdpath#config,
      \ 'C': g:stdpath#cache,
      \ 'd': g:stdpath#data,
      \ 'G': '~/GitHub/',
      \ 'N': '~/GitHub/neovim/',
      \ 'P': $PACKDIR,
      \ 'v': $VIMRUNTIME..'/lua/vim',
      \ 'V': $VIMRUNTIME,
      \ 's': g:stdpath#state,
      \ '.': '~/.local/share/chezmoi/'
      \ }

for [k, v] in items(s:dirs)
  execute $'nnoremap cd{k} <Cmd>edit {v}<CR>'
endfor

" TODO: unlearn these maps
" nnoremap <Bslash>i <Cmd>call edit#($MYVIMRC)<CR>
" nnoremap <Bslash>0 <Cmd>call edit#readme()<CR>
