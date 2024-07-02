function! utils#smartQuit() abort
    if winnr('$') > 1
        bnext | 1wincmd w | q
    else
        if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1
            bnext | bd# | 1wincmd w
        else
            quit
        endif
    endif
endfunction

function! utils#lol () abort
  echom ">^.^<" | redraw
endfunction

function! utils#getInfo()
    let l:word = expand('<cword>')
    try
        execute 'ptag' l:word
    catch
        try
            execute 'help' l:word
        catch
            try
                execute 'Man' l:word
            catch
                echo "No info found for " . l:word
            endtry
        endtry
    endtry
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

" vim:foldmethod=marker:foldmarker=function!,endfunction
