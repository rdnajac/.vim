" better format automatic foldmarkers with `zf`
setlocal commentstring=\ \"\ %s
setlocal iskeyword-=#

if has('nvim')
  lua vim.treesitter.start()
endif
