" better format automatic foldmarkers with `zf`
setlocal commentstring=\ \"\ %s
setlocal foldmethod=marker
setlocal foldlevel=1
setlocal iskeyword-=#
" setlocal foldtext=fold#text()

if has('nvim')
  lua vim.treesitter.start()
endif
