local M = { 'nvim-treesitter/nvim-treesitter' }

M.version = 'main'

M.dependencies = {
  {
    src = 'nvim-treesitter/nvim-treesitter-textobjects',
    version = M.version,
  },
}

-- FIXME: TSUpdate is not available until after setup is called
M.build = function()
  Snacks.util.on_module('nvim-treesitter', function()
    dd('Updating nvim-treesitter...')
    vim.cmd('TSUpdate')
  end)
end

local aug = vim.api.nvim_create_augroup('treesitter', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'sh', 'tex', 'markdown', 'python', 'vim' },
  group = aug,
  callback = function()
    vim.treesitter.start()
  end,
  desc = 'Start treesitter for certiain file types',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'kitty', 'ghostty', 'zsh' },
  group = aug,
  callback = function(ev)
    vim.treesitter.language.register('bash', ev.match)
    vim.treesitter.start(0, 'bash')
  end,
  desc = 'Force some file types to use `bash` treesitter (and commentstring)',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'kitty', 'ghostty', 'ghostty.chezmoitmpl' },
  group = aug,
  callback = function()
    vim.cmd([[setlocal commentstring=#\ %s]])
  end,
  desc = 'Force some file types to use `bash` treesitter (and commentstring)',
})

local register_custom_parser = function()
  require('nvim-treesitter.parsers').comment = {
    install_info = {
      url = 'https://github.com/rdnajac/tree-sitter-comment',
      generate = true,
      queries = 'queries/neovim',
    },
  }
end

M.config = function()
  local parsers = require('nvim.treesitter.parsers')
  require('nvim-treesitter').install(parsers)
  require('nvim.treesitter.comments').setup()
  require('nvim.treesitter.selection').setup()

  -- require('nvim.treesitter.comments')
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.api.nvim_create_autocmd('User', {
    pattern = 'TSUpdate',
    group = aug,
    callback = function(ev)
      register_custom_parser()
    end,
    desc = 'Install custom parser that highlights strings in `backticks` in comments',
  })
end

return M
