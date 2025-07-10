local chezmor_dir = os.getenv('HOME') .. '/.local/share/chezmoi'

-- chezmoi.vim
vim.g['chezmoi#use_tmp_buffer'] = 1
vim.g['chezmoi#source_dir_path'] = chezmor_dir

-- chezmoi.nvim
require('chezmoi').setup({})
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { chezmor_dir .. '/**' },
  callback = function()
    vim.schedule(require('chezmoi.commands.__edit').watch)
  end,
})
