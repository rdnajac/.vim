" TODO: move to col.vim or something
" set foldcolumn=1
set signcolumn=number
" set numberwidth=3

let &laststatus = has('nvim') ? 3 : 2

" TODO: move to nv.ui
" set statuscolumn=%!vimline#statuscolumn#()
" set statuscolumn=%!v:lua.require'vimline.statuscolumn'()
" set statuscolumn=%{if(&number,printf('%4d',v:lnum),repeat(' ',4)).'│'}
