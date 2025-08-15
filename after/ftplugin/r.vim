setlocal iskeyword-=.

setlocal formatexpr=
" FIXME: this adds unwanted text to the start of the file
" let &l:formatprg = "Rscript -e \"con <- file('stdin'); src <- readLines(con); close(con); cat(styler::style_text(src), sep = '\\n')\""

" Note that not all terminals handle these key presses the same way
inoremap <buffer> <M--> <-<Space>
inoremap <buffer> <M-Bslash> <bar>><Space>

" TODO: move to snippets
inoremap <buffer> ins<Tab> renv::install("")<Left><Left>
inoremap <buffer> lib<Tab> library()<Left>
