" plugin/cmd.vim
nnoremap ; :

cnoreabbrev <expr> %% expand('%:p:h')
cnoreabbrev !! !./%
cnoreabbrev scp !./%
cnoreabbrev ?? verbose set?<Left>
cnoreabbrev <expr> vv getcmdtype() == ':' && getcmdline() =~ '^vv' ? 'verbose' : 'vv'
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
