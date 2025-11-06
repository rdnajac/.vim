-- default tree-sitter parsers bundled with neovim: `~/.local/share/nvim/lib/nvim/parser/`
local defaults = { 'c', 'lua', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }

-- `~/.local/share/nvim/site/`
-- - `parser/`: contains the parsers (`.so` files)
-- - `parser-info/`: contains the download information
-- - `query/`: installed queries for the syntax highlighting
local parsers = {
  -- 'asm',
  'bash',
  -- 'bibtex',
  -- 'csv',
  -- 'cmake',
  -- 'cpp',
  -- 'cuda',
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
  'latex', -- Snacks.image
  -- 'llvm',
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
  'zsh',
}

-- local snacks_image_supported_filetypes = Snacks.image.langs()
return vim.tbl_extend('force', {}, defaults, parsers)
