" heads-up!
function! g:Tabline()
    let s = ''
    for bufnr in filter(range(1, bufnr('$')), 'buflisted(v:val)')
        let s .= '%' . bufnr . 'T'
        let s .= bufnr == bufnr('%') ? '%#TabLineSel#' : '%#TabLine#'
        let s .= getbufvar(bufnr, "&mod") ? '  📝' : '  💾'
        let s .= bufname(bufnr)!= '' ? fnamemodify(bufname(bufnr), ':t') : '[∅]'
        "let s .= '%X ❌%X'
    endfor
    let s .= '%#TabLineFill#%T'
    return s
endfunction

set tabline=%!g:Tabline()
set showtabline=2

" clear the statusline so we can start fresh
set laststatus=0
set statusline=
set statusline+=%{FugitiveStatusline()}   " Git branch
set statusline+=\ %F\ %M\ %y\ %r          " File path, modified flag, file type, read-only flag
set statusline+=%=                        " Right align the following items
" set statusline+=ascii:\ %3b\ hex:\ 0x%02B\ " ASCII and hex value of char under cursor
set statusline+=[%2v,\%P]

function! ToggleOverlay()
  if &showtabline == 2
    set showtabline=0
    set laststatus=2
  else
    set showtabline=2
    set laststatus=0
  endif
endfunction
nnoremap <leader>i :call ToggleOverlay()<CR>
