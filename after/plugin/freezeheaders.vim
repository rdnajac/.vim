function! FreezeHeaders()
    " Get the first line which contains the headers
    let headers = getline(1)
    let formatted_line = substitute(headers, '\t', ' | ', 'g') " Replace tabs with '|' for visibility

    " Set the tabline to display the formatted first line
    let &l:tabline = '%=%#TabLine#' . formatted_line . '%#TabLineFill#%T'

    " Apply concealment to hide the first line
    execute 'syntax match ConcealedLine "^' . headers . '$" containedin=ALL conceal cchar='
    setlocal conceallevel=2
    setlocal concealcursor=nc
endfunction

