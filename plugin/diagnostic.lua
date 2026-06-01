local severity = vim.diagnostic.severity
local severity_map = {
  E = severity.ERROR,
  W = severity.WARN,
  I = severity.INFO,
}
-- local hl_map = {
--   [severity.ERROR] = 'DiagnosticSignError',
--   [severity.WARN] = 'DiagnosticSignWarn',
--   [severity.INFO] = 'DiagnosticSignInfo',
--   [severity.HINT] = 'DiagnosticSignHint',
-- }
local icons = {
  [severity.ERROR] = '',
  [severity.WARN] = '',
  [severity.INFO] = '',
  [severity.HINT] = '',
  -- Error = '',
  -- Warn = '',
  -- Info = '',
  -- Hint = '',
}
-- local icons = { '', '', '', '' }

vim.diagnostic.config({
  float = { source = true },
  underline = false,
  virtual_text = false,
  severity_sort = true,
  signs = { text = icons },
})

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
