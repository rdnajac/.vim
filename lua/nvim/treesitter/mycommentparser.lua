---@diagnostic disable-next-line: param-type-mismatch
vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  group = 'treesitter',
  callback = function()
    require('nvim-treesitter.parsers').comment = {
      install_info = {
        url = 'https://github.com/rdnajac/tree-sitter-comment',
        generate = true,
        queries = 'queries/neovim',
      },
    }
  end,
  desc = 'Install custom parser that highlights strings in `backticks` in comments',
})
