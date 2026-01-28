" plugin/fold.vim
" better search if auto pausing folds
" set foldopen-=search
" nnoremap <silent> / zn/

nnoremap          zv zMzvzz
nnoremap <silent> zj zcjzOzz
nnoremap <silent> zk zckzOzz
" close folds when moving left at beginning of line
" TODO: make it wrap like whichwrap+=h or (col('.') == 1 ? 'gk$' : 'h')
nnoremap <expr> h virtcol('.') <= indent('.') + 1 ? 'zc' : 'h'

" save, override, and restore commentstring to get nice folds
xnoremap zf :<C-u>let s=&l:cms \| let &l:cms=' '.s \| '<,'>fold \| let &l:cms=s<CR>
