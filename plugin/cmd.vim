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
cnoreabbrev <expr> snacks getcmdtype() == ':' && getcmdline() =~ '^snacks' ? 'lua Snacks' : 'snacks'

function! s:cab(from, to, exact) abort
  let l:pattern = a:exact ? '^' . a:from . '\s*$' : '^' . a:from
  execute printf(
	\ 'cnoreabbrev <expr> %s (getcmdtype() ==# ":" && getcmdline() =~# "%s") ? "%s" : "%s"',
	\ a:from, l:pattern, a:to, a:from
	\ )
endfunction

call s:cab('f', 'find', v:false)

" command definitions are more robust than abbreviations
command! E e!
command! W w!
command! Wq wq!
command! Wqa wqa!
command! -bang Quit call quit#buffer(<q-bang>)

" TOOD: move to plugin/scp.vim
command! -nargs=1 -complete=customlist,bin#scp#complete Scp call bin#scp#scp(<f-args>)

command! -nargs=0 Format call execute#inPlace('call format#buffer()')

command! -nargs=+ DiffBufs
      \ call execute('buffer ' . split(<q-args>)[0]) |
      \ call execute('vert sbuffer ' . split(<q-args>)[1]) |
      \ diffthis |
      \ wincmd p |
      \ diffthis

if exists(':DiffOrig') != 2
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
	\ | diffthis | wincmd p | diffthis
endif
