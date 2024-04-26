" function MySTL()
"   if has("statusline")
"     hi User1 term=standout ctermfg=0 ctermbg=11 guifg=Black guibg=Yellow
"     let stl = ''
"     if exists("*CSV_WCol")
"       let csv = '%1*%{&ft=~"csv" ? CSV_WCol() : ""}%*'
"     else
"       let csv = ''
"     endif
"     return stl.csv
"   endif
" endfunc
" set stl=%!MySTL()
" set laststatus=2
