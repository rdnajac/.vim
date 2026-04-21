--- Default tree-sitter parsers bundled with neovim:
--- `c`, `lua`, `query`, `vim`, `vimdoc`,
--- `markdown`, and `markdown_inline`

--installing via treesitter lets us use additional queries
---
--- Parser directories
--- - `parser/`: contains the parsers (`.so` files)
--- - `parser-info/`: contains the download information
--- - `query/`: installed queries for the syntax highlighting

---@alias ParserConfig boolean|string|string[]
--- - `false`: install, but do not autostart
--- - `true`: install parser, autostart for all default filetype
--- - `string|string[]`: install parser, autostart with given filetype(s)

---@type table<string, ParserConfig>
return {
  -- bash = { 'sh', 'bash' },
  bash = true,
  -- bibtex = false,
  -- csv = false,
  -- cmake = false,
  -- cpp = false,
  -- cuda = false,
  css = true,
  -- diff = false,
  -- dockerfile = false,
  -- doxygen = false,
  fish = true,
  -- git_config = false,
  -- gitcommit = false,
  -- git_rebase = false,
-- gitattributes = false,
  -- gitignore = false,
  -- groovy = false,
  html = true,
  javascript = true,
  json = true,
  latex = false, -- required for `Snacks.image`, do not autostart
  just = true,
  -- llvm = false,
  lua = false, -- `$VIMRUNTIME/ftplugin/lua.lua` already starts treesitter
  markdown = true, -- `R.nvim` plugin will register `rmd` and `quarto` fts
  make = true,
  -- ocaml = false,
  printf = true,
  python = true,
  r = true,
  regex = false,
  rnoweb = false,
  toml = true,
  -- typescript = true,
  vim = true,
  -- xml = false,
  yaml = true,
  zsh = true,
}
