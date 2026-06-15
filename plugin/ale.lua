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

local severity = vim.diagnostic.severity
local severity_map = {
  E = severity.ERROR,
  W = severity.WARN,
  I = severity.INFO,
}

--- Send diagnostics to the Neovim diagnostics API
---@param buf number The buffer number to retreive the variable for.
---@param loclist table The loclist array to report as diagnostics.
---@return nil
local ale_send = function(buf, loclist)
  local diagnostics = vim
    .iter(loclist)
    :filter(function(location) return location.bufnr == buf end)
    :map(
      function(location)
        return {
          lnum = location.lnum - 1,
          end_lnum = (location.end_lnum or location.lnum) - 1,
          col = math.max((location.col or 1) - 1, 0),
          end_col = location.end_col,
          severity = severity_map[location.type] or 'E',
          code = location.code,
          message = location.text,
          source = location.linter_name,
        }
      end
    )
    :totable()
  local ns = vim.api.nvim_create_namespace('ale')
  vim.diagnostic.set(ns, buf, diagnostics, {})
end

-- HACK: override the default `ale.diagnostics` lua module
package.preload['ale.diagnostics'] = function() return { send = ale_send } end
