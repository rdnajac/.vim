local ensure_installed = {
  -- 'asm',
  'bash',
  -- 'bibtex',
  'csv',
  'cmake',
  'cpp',
  'cuda',
  -- this should be `highlighted` or
  -- `hi` or nor `w
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

return {
  { 'folke/ts-comments.nvim', event = 'VeryLazy', opts = {} },
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    init = function()
      -- FIXME: don't chagne the source code!
      -- require('nvim-treesitter.parsers').comment = {
      --   install_info = {
      --     path = vim.fn.expand('~/GitHub/rdnajac/tree-sitter-comment'),
      --     -- files = { 'src/parser.c' },
      --   },
      -- }
      -- print(vim.inspect(require('nvim-treesitter.parsers').comment))
      require('nvim-treesitter').install(ensure_installed)
    end,
  },
  config = { install_dir = vim.fn.stdpath('data') .. '/site' },
}
