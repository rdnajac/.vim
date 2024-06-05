" vim functions go here

function! GetInfo()
    let l:word = expand('<cword>')
    try
        " execute 'tag' l:word
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

nnoremap ! :call GetInfo()<CR>

function! HighlightGroup()
    let l:word = expand('<cword>')
    let l:highlight_group = synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
    return l:highlight_group
endfunction
nnoremap <silent> <leader>hi :echo HighlightGroup()<CR>

function! NewCHeader(filename)
    let headerFilename = a:filename . ".h"
    let capsFilename = toupper(a:filename)
    let content = ["#ifndef _" . capsFilename . "_H", "#define _" . capsFilename . "_H", "", "#endif /* _" . capsFilename . "_H */"]
    call writefile(content, headerFilename)
    echo "header file created: " . headerFilename
endfunction

function! StripTrailingWhitespace()
  if !&binary && &filetype != 'diff'
    let l:save_cursor = getpos(".")
    let l:save_view = winsaveview()
    %s/\s\+$//e
    call setpos('.', l:save_cursor)
    call winrestview(l:save_view)
  endif
endfunction
"nnoremap <leader>w :call StripTrailingWhitespace()<CR> :w<CR>
nnoremap <leader>w :w<CR>

function! ReplaceSelection()
    normal! gv"xy
    let sel = getreg('x')
    let rep = input('Replace all instances of "' . sel . '" with: ')
    if rep != ''
      let cmd = ':%s/' . escape(sel, '/\') . '/' . escape(rep, '/\') . '/g'
      exe cmd
    endif
endfunction
xnoremap <leader>r :<C-u>call ReplaceSelection()<CR>

function! Xexplore()
    let cmd = "Lexplore"            " set default command
    if expand('%:p') =~ '^scp://'   " check if current file is on remote server
        cmd .= ' scp://' . substitute(expand('%:p'), '^scp://\([^/]\+\)/', '', '') . '/'
    endif
    execute cmd
endfunction

nnoremap <leader><Tab> :call Xexplore()<CR>

function! HighlightGroup()
    let l:word = expand('<cword>')
    let l:highlight_group = synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
    return l:highlight_group
endfunction
nnoremap <silent> <leader>hi :echo HighlightGroup()<CR>

function! NewCHeader(filename)
    let headerFilename = a:filename . ".h"
    let capsFilename = toupper(a:filename)
    let content = ["#ifndef _" . capsFilename . "_H", "#define _" . capsFilename . "_H", "", "#endif /* _" . capsFilename . "_H */"]
    call writefile(content, headerFilename)
    echo "header file created: " . headerFilename
endfunction

function! Xexplore()
    let cmd = "Lexplore"            " set default command
    if expand('%:p') =~ '^scp://'   " check if current file is on remote server
        cmd .= ' scp://' . substitute(expand('%:p'), '^scp://\([^/]\+\)/', '', '') . '/'
    endif
    execute cmd
endfunction

nnoremap <leader><Tab> :call Xexplore()<CR>

function! SmartQuit()
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
nnoremap <leader>q :call SmartQuit()<CR>

