--- Default tree-sitter parsers bundled with neovim:
--- `c`, `lua`, `query`, `vim`, `vimdoc`,
--- `markdown`, and `markdown_inline`

--installing via treesitter lets us use additional queries
---
--- Parser directories
--- - `parser/`: contains the parsers (`.so` files)
--- - `parser-info/`: contains the download information
--- - `query/`: installed queries for the syntax highlighting

return {
  'bash',
  -- 'bibtex',
  'csv',
  -- 'cmake',
  -- 'cpp',
  -- 'cuda',
  'css',
  -- 'diff',
  -- 'dockerfile',
  -- 'doxygen',
  'fish',
  'html',
  'javascript',
  'json',
  'latex', --  do not autostart
  'just',
  -- 'llvm',
  'lua', -- `$VIMRUNTIME/ftplugin/lua.lua` already starts treesitter
  'markdown', -- `R.nvim` plugin will register `rmd` and `quarto` fts
  'make',
  -- 'ocaml' ,
  'printf',
  'python',
  'r',
  'regex',
  'rnoweb',
  'toml',
  'vim',
  'xml',
  'yaml',
  'zsh',
}
