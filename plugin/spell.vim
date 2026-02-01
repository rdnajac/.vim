" see `:h :mkspell`
let &spellfile = g:['vimrc#dir'] . '/.spell/en.utf-8.add'

augroup spelling
  autocmd!
  " autocmd FileType tex,markdown,rmd,quarto setlocal spell
augroup END
" TODO: download cspell dictionaries and apply them per ft
" https://github.com/streetsidesoftware/cspell-dicts/blob/main/dictionaries/vim/dict/vim.txt
" or just use cspell...
