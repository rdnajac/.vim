" vim/autoload/info.vim
function! info#highlight_group() abort
    let hl_group = synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
    call g:PopupShow('Highlight Group: ' . hl_group)
endfunction

function! info#syntax_group() abort
    let syntax_group = synIDtrans(synID(line('.'), col('.'), 0))
    call g:PopupShow('Syntax Group: ' . syntax_group)
endfunction

function! info#get() abort
    let line_num = line(".")
    let col_num = col(".")
    let syn_id = synIDtrans(synID(line_num, col_num, 1))
    let output = [
        \ 'Syntax: ' . synIDattr(syn_id, "name"),
        \ 'Highlight group: ' . synIDattr(syn_id, "name"),
        \ 'Line number: ' . line_num,
        \ 'Column number: ' . col_num,
        \ 'Cursor position: ' . line_num . ',' . col_num
        \ ]
    for id in synstack(line_num, col_num)
        call add(output, 'Highlight group: ' . synIDattr(id, "name"))
    endfor
    call g:PopupShow(join(output, "\n"))
endfunction