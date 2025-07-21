set showcmdloc=statusline
set statusline=%!MyStatusline()
let &laststatus = has('nvim') ? 3 : 2
set noruler
" set tabline=%!MyTabline()
" set showtabline=2
" set winbar=%!MyWinbar()
