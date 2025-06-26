" better format automatic foldmarkers with `zf`
setlocal commentstring=\ \"\ %s
setlocal iskeyword-=#

nnoremap <leader>ch <Cmd>call edit#ch()<CR>

if has('nvim')
  lua vim.treesitter.start()
endif
