-- Setup netrw with git status extmarks
require('nvim.util.git.netrw_exmarks').setup()

-- Configure netrw to show sign column
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  callback = function()
    vim.wo.signcolumn = 'yes:2'
  end,
})
