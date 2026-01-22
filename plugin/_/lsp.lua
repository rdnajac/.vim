local nv = _G.nv or require('nvim')
vim.schedule(function() vim.lsp.enable(nv.lsp.servers()) end)
