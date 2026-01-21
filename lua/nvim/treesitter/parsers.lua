-- default tree-sitter parsers bundled with neovim: `~/.local/share/nvim/lib/nvim/parser/`
local defaults = { 'c', 'lua', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }
-- `~/.local/share/nvim/site/`
-- - `parser/`: contains the parsers (`.so` files)
-- - `parser-info/`: contains the download information
-- - `query/`: installed queries for the syntax highlighting

---@alias ParserConfig boolean|string|string[]
--- - `false`: install, but do not autostart
--- - `true`: install parser, autostart for all default filetype
--- - `string|string[]`: install parser, autostart with given filetype(s)

---@type table<string, ParserConfig>
local parsers = {
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
  -- llvm = false,
  lua = true,
  -- make = false,
  markdown = true,
  -- ocaml = false,
  printf = false,
  python = true,
  r = { 'r', 'rmd', 'quarto' },
  regex = false,
  rnoweb = false,
  toml = true,
  typescript = true,
  vim = true,
  -- xml = false,
  yaml = true,
  zsh = true,
}

local M = {}

M.to_install = vim
  .iter(parsers)
  :filter(function(k, v) return not vim.tbl_contains(defaults, k) end)
  :map(function(k, _) return k end)
  :totable()

M.to_autostart = vim
  .iter(parsers)
  :filter(function(k, v) return v ~= false end)
  :map(function(k, _) return k end)
  :totable()

return M
