-- Incremental selection

local M = {}

M.parsers = {
  -- 'asm',
  'bash',
  -- 'bibtex',
  'csv',
  'cmake',
  'cpp',
  'cuda',
  'comment', -- HACK: this is a custom parser
  'diff',
  'dockerfile',
  'doxygen',
  'git_config',
  'gitcommit',
  'git_rebase',
  'gitattributes',
  'gitignore',
  'gitcommit',
  -- 'groovy',
  'html',
  'javascript',
  'jsdoc',
  'json',
  'jsonc',
  -- 'json5',
  'latex',
  'llvm',
  'luadoc',
  'luap',
  'make',
  'ocaml',
  'printf',
  'python',
  'regex',
  'r',
  'rnoweb',
  'toml',
  'xml',
  'yaml',
}

M.register_parser = function()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'TSUpdate',
    callback = function()
      require('nvim-treesitter.parsers').comment = {
        install_info = {
          path = vim.fn.expand('~/GitHub/rdnajac/tree-sitter-comment'),
          -- optional entries:
          -- TODO: track parser in this repo
          -- location = 'parser', -- only needed if the parser is in subdirectory of a "monorepo"
          -- TODO:
          -- generate = true, -- only needed if repo does not contain pre-generated `src/parser.c`
          -- TODO:
          -- generate_from_json = false, -- only needed if repo does not contain `src/grammar.json` either
          -- TODO:
          -- queries = 'queries/neovim', -- also install queries from given directory
        },
      }
    end,
  })
end

-- stylua: ignore
M.setup = function()
M.register_parser()
require('nvim-treesitter').install(M.parsers)
local sel = require('nvim.treesitter.selection')

vim.keymap.set('n', '<C-Space>', function() sel.start()     end, { desc = 'Start     selection' })
vim.keymap.set('x', '<C-Space>', function() sel.increment() end, { desc = 'Increment selection' })
vim.keymap.set('x', '<BS>',      function() sel.decrement() end, { desc = 'Decrement selection' })
end

return M
