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

" helpers for selection
function! s:v_sel() abort
    normal! gv"xy
    return getreg('x')
endfunction

function utils#test()
    echom s:v_sel()
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
    normal! gv"xy
    let selection = getreg('x')
  echom l:selection
  " if l:selection =~ '^https\?://'  " Check if selection starts with http or https
  "   execute "normal! c[`M](<C-r>\")mM"
  " else
  "   execute "normal! c[<C-r>\"]()"
  " endif
endfunction


" vim:foldmethod=marker:foldmarker=function!,endfunction
