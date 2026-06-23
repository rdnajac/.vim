-- HACK: override the default `ale.diagnostics` lua module
package.preload['ale.diagnostics'] = function()
  return { send = nv.diagnostic.ale_send }
end

vim.g.ale_disable_lsp = 1
vim.g.ale_echo_cursor = 'never'
vim.g.ale_lint_on_text_changed = 'never'
vim.g.ale_linters_explicit = 1
vim.g.ale_virtualtext_cursor = 0

vim.g.ale_fixers = {
  ['*'] = { 'remove_trailing_lines', 'trim_whitespace' },
  python = { 'ruff' },
  markdown = { 'rumdl' },
  lua = { 'stylua' },
}

vim.g.ale_linters = {
  vim = { 'vint' },
}

vim.diagnostic.config({
  float = { source = true },
  underline = false,
  virtual_text = false,
  severity_sort = true,
  -- signs = { text = { '', '', '', '' } },
  signs = { text = nv.diagnostic.icons },
})
