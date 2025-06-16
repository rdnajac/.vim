return {
  { 'folke/ts-comments.nvim', event = 'VeryLazy', opts = {} },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false,
    opts = {
      ensure_installed = {
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
      },
      -- these come bundled with neovim
      ignore_install = {
        'c',
        'lua',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
      },
    },
    -- config = function(_, opts)
    --   -- FIXME: the parse doesn't automatically install from `GitHub`
    --   require('nvim-treesitter.parsers').get_parser_configs().comment = {
    --     install_info = {
    --       url = '~/GitHub/rdnajac/tree-sitter-comment',
    --       files = { 'src/parser.c' },
    --       branch = 'main',
    --     },
    --   }
    -- end,
  },
}
