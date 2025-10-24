let &spellfile = my#vimdir . '/.spell/en.utf-8.add'

augroup spelling
	autocmd!
	" autocmd FileType tex,markdown,rmd,quarto setlocal spell
augroup END
" TODO: ownload cspell dictionaries and apply them per ft
" https://github.com/streetsidesoftware/cspell-dicts/blob/main/dictionaries/vim/dict/vim.txt
