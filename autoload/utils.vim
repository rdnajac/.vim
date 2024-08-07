function! utils#lol() abort
  echom ">^.^<" | redraw
endfunction

function! utils#smartQuit() abort
    " if we have a split window, try to preserve it
    if winnr('$') > 1
        bnext | 1wincmd w | q!
    else
        if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1
            bnext | bd# | 1wincmd w
        else
            quit!
        endif
    endif
endfunction

function! utils#replaceSelection() abort
    normal! gv"xy
    let sel = getreg('x')
    let rep = input('Replace all instances of "' . sel . '" with: ')
    if rep != ''
      let cmd = ':%s/' . escape(sel, '/\') . '/' . escape(rep, '/\') . '/g'
      exe cmd
    endif
endfunction

function! utils#SheBangs(shebang)
    let shebang = empty(a:shebang) ? '#!/bin/bash' : a:shebang
    call append(0, [shebang, '#', '## '])
    execute "normal! Xa"
endfunction

function! utils#Hyperlink() abort
  " if l:selection =~ '^https\?://'  " Check if selection starts with http or https
  "   execute "normal! c[`M](<C-r>\")mM"
  " else
  "   execute "normal! c[<C-r>\"]()"
  " endif
endfunction

"https://web.archive.org/web/20230418005002/https://www.vi-improved.org/recommendations/
function! utils#remove_trailing_whitespace() abort
    if !&binary && &filetype != 'diff'
	let size = line2byte(line('$') + 1) - 1
	normal mz
	normal Hmy
	%s/\s\+$//e
	normal 'yz<CR>
	normal z
	let final_size = line2byte(line('$') + 1) - 1
	if final_size != size
	    echomsg "Stripped " . (size - final_size) . " bytes of trailing whitespace."
	endif
    endif
endfunction
