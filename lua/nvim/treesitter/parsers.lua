--- Default tree-sitter parsers bundled with neovim:
--- `c`, `lua`, `query`, `vim`, `vimdoc`,
--- `markdown`, and `markdown_inline`
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
  -- asm = false,
  bash = { 'sh', 'bash' },
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
  latex = false, -- Snacks.image, no autostart
  just = true,
  -- llvm = false,
  -- installing via treesitter lets us use additional queries
  lua = false, -- don't autostart since ftplugin/lua.lua already does
  make = true,
  markdown = { 'markdown', 'rmd', 'quarto' },
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
