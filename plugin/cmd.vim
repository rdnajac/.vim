" plugin/cmd.vim
nnoremap ; :

cnoreabbrev <expr> %% expand('%:p:h')
cnoreabbrev !! !./%
cnoreabbrev scp !./%
cnoreabbrev ?? verbose set?<Left>
cnoreabbrev <expr> scp getcmdtype() == ':' && getcmdline() =~ '^scp' ? '!scp %' : 'scp'
cnoreabbrev <expr> require getcmdtype() == ':' && getcmdline() =~ '^require' ? 'lua require' : 'require'
cnoreabbrev <expr> man (getcmdtype() ==# ':' && getcmdline() =~# '^man\s*$') ? 'Man' : 'man'
cnoreabbrev <expr> Snacks getcmdtype() == ':' && getcmdline() =~ '^Snacks' ? 'lua Snacks' : 'Snacks'
cnoreabbrev <expr> snacks getcmdtype() == ':' && getcmdline() =~ '^snacks' ? 'lua Snacks' : 'snacks'

" command definitions are more robust than abbreviations
command! E e!
command! W w!
command! Wq wq!
command! Wqa wqa!
command! -bang Quit call quit#buffer(<q-bang>)

" TOOD: move to plugin/scp.vim
command! -nargs=1 -complete=customlist,bin#scp#complete Scp call bin#scp#scp(<f-args>)

command! -nargs=+ DiffBufs
      \ call execute('buffer ' . split(<q-args>)[0]) |
      \ call execute('vert sbuffer ' . split(<q-args>)[1]) |
      \ diffthis |
      \ wincmd p |
      \ diffthis
