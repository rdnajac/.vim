" Replace all instances of the selected text with a new string
" note: does not work with empty string replacements
function! ReplaceSelection() abort
    normal! gv"xy
    let sel = getreg('x')
    let rep = input('Replace all instances of "' . sel . '" with: ')
    if rep != ''
      let cmd = ':%s/' . escape(sel, '/\') . '/' . escape(rep, '/\') . '/g'
      exe cmd
    endif
endfunction
xnoremap <leader>r :<C-u>call ReplaceSelection()<CR>
