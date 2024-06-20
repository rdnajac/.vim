" Get info on the word under the cursor
" First, try to find a tag, then a help, finally man pages

function! GetInfo()
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
nnoremap ! :call GetInfo()<CR>
