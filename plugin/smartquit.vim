" Quit Vim without closing the last window
function! SmartQuit() abort
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