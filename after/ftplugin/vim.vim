" better format automatic foldmarkers with `zf`
setlocal commentstring=\ \"\ %s
setlocal foldmethod=marker
setlocal iskeyword-=#
setlocal foldtext=fold#text()

if has('nvim')
  lua vim.treesitter.start()
endif
