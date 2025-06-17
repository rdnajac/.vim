local ensure_installed = {
  -- 'asm',
  'bash',
  -- 'bibtex',
  'csv',
  'cmake',
  'cpp',
  'cuda',
  -- FIXME
  -- 'comment', -- HACK: this is a custom parser
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
      require('nvim-treesitter').install(ensure_installed)
    end,
    config = {
      install_dir = vim.fn.stdpath('data') .. '/site',
    },
    --   -- FIXME: the parse doesn't automatically install from `GitHub`
    --   require('nvim-treesitter.parsers').get_parser_configs().comment = {
    --     install_info = {
    --       url = '~/GitHub/rdnajac/tree-sitter-comment',
    --       files = { 'src/parser.c' },
    --       branch = 'main',
    --     },
  },
}
