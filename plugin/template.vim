augroup template
  autocmd!
  autocmd BufReadPost *.template execute 'set ft='..fnamemodify(expand('<afile>'), ':p:t:r:e')
  autocmd BufNewFile */after/lsp/*.lua call template#read('lsp.lua.template')
augroup END
