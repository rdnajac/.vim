" vim/autoload/format.vim

function! format#buffer() abort
    let winview = winsaveview()
    normal! gggqG
    if v:shell_error > 0
        silent undo
        redraw
        echomsg 'formatprg "' . &formatprg . '" exited with status ' . v:shell_error
    endif
    call winrestview(winview)
endfunction

function! format#remove_trailing_whitespace() abort
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
