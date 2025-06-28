" better format automatic foldmarkers with `zf`
setlocal commentstring=\ \"\ %s
setlocal iskeyword-=#
setlocal formatoptions -=ro

let b:ale_linters = ['vint']

nnoremap <leader>ch <Cmd>call edit#ch()<CR>

if has('nvim')
  lua vim.treesitter.start()
endif
