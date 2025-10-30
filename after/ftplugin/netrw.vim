setlocal nobuflisted
setlocal bufhidden=wipe
" Info b:netrw_curdir
" lcd b:netrw_curdir

silent! nunmap <buffer> d
nmap <buffer> dd D
" echom netrw#Expose("netrwmarkfilelist_{bufnr('%')}")`
