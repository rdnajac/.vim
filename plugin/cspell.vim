let &spellfile = vimrc#home() . '/.spell/en.utf-8.add'

augroup spelling
	autocmd!
	autocmd FileType markdown,tex setlocal spell
	autocmd FileType rmarkdown,quarto setlocal spell
augroup END
" Download cspell dictionaries and apply them per ft
" https://github.com/streetsidesoftware/cspell-dicts/blob/main/dictionaries/vim/dict/vim.txt
