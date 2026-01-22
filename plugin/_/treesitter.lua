local nv = _G.nv or require('nvim')
local aug = vim.api.nvim_create_augroup('treesitter', {})

vim.api.nvim_create_autocmd('FileType', {
  pattern = nv.treesitter.parsers.to_autostart,
  group = aug,
  callback = function(ev) vim.treesitter.start(ev.buf) end,
  desc = 'Automatically start tree-sitter',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'r', 'rmd', 'quarto' },
  group = aug,
  command = 'setlocal foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()',
  desc = 'Use treesitter folding for select filetypes',
})

nv.treesitter.selection.create_mappings()
