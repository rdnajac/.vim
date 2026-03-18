-- Parser directories
-- - `parser/`: contains the parsers (`.so` files)
-- - `parser-info/`: contains the download information
-- - `query/`: installed queries for the syntax highlighting
-- default tree-sitter parsers bundled with neovim:
local defaults = { 'c', 'lua', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }

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
  printf = true,
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

local M = {
  ---@return string[] parsers installed by nvim-treesitter
  installed = function() return require('nvim-treesitter').get_installed('parsers') end,

  ---@return string[] parsers nvim-treesitter should install
  to_install = function()
    return vim
      .iter(parsers)
      :filter(function(k, _) return not vim.tbl_contains(defaults, k) end)
      :map(function(k, _) return k end)
      :totable()
  end,

  ---@return string[] parsers to start on FileType event
  to_autostart = function()
    return vim
      .iter(parsers)
      :filter(function(_, v) return v ~= false end)
      :map(function(k, _) return k end)
      :totable()
  end,
}

return M
