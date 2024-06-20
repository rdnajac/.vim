function! hud#MyTabline()
    let s = ''
    let current_buf = bufnr('%')
    for bufnum in filter(range(1, bufnr('$')), 'buflisted(v:val)')
        let s .= '%' . bufnum . 'T'
        let s .= (bufnum == current_buf ? '%#TabLineSel#' : '%#TabLine#')
        let s .= getbufvar(bufnum, "&mod") ? '  📝' : '  💾'
        let bufname_display = (bufnum == current_buf) ? bufname(bufnum) : fnamemodify(bufname(bufnum), ':t')
        let s .= bufname_display != '' ? bufname_display : '[∅]'
    endfor
    let s .= '%#TabLineFill#%T'
    return s
endfunction
