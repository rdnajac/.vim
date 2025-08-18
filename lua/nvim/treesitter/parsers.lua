-- default parsers bundled with neovim can be found at: `~/.local/share/nvim/lib/nvim/parser/`
local defaults = {
  'c',
  'lua',
  'markdown',
  'markdown_inline',
  'query',
  'vim',
  'vimdoc',
}

-- Table of parsers to automatically install with nvim-treesitter
-- NOTE: They still have to be manually enabled for most filetypes
-- see `<url>` for available parsers
-- also check `~/.local/share/nvim/site/` for the following directories:
-- - `parser/`: contains the parsers 
-- - `parser-info/`: contains the download information
-- - `query/`: installed queries for the syntax highlighting
local parsers  = {
  -- 'asm',
  'bash',
  -- 'bibtex',
  -- 'csv',
  -- 'cmake',
  -- 'cpp',
  -- 'cuda',
  'comment', -- HACK: this is a custom parser
  -- 'diff',
  -- 'dockerfile',
  -- 'doxygen',
  -- 'git_config',
  -- 'gitcommit',
  -- 'git_rebase',
  -- 'gitattributes',
  -- 'gitignore',
  -- 'gitcommit',
  -- 'groovy',
  -- 'html',
  -- 'javascript',
  -- 'jsdoc',
  -- 'json',
  -- 'jsonc',
  -- 'json5',
  -- 'latex',
  -- 'llvm',
  -- 'luadoc',
  -- 'luap',
  -- 'make',
  -- 'ocaml',
  'printf',
  'python',
  'regex',
  'r',
  'rnoweb',
  'toml',
  -- 'xml',
  'yaml',
}

return vim.tbl_extend('force', defaults, parsers)
