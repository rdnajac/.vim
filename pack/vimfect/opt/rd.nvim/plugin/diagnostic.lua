local severity = vim.diagnostic.severity
local severity_map = {
  E = severity.ERROR,
  W = severity.WARN,
  I = severity.INFO,
}

-- TODO: use table invert fn
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

local hl_map = {
  [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
  [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
  [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
  [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
}

local M = {}

---@type  vim.diagnostic.Opts
M.opts = {
  float = { source = true },
  underline = false,
  virtual_text = false,
  severity_sort = true,
  signs = { text = icons },
}

vim.diagnostic.config(M.opts)

M.ale = function()
  return {
    --- Send diagnostics to the Neovim diagnostics API
    ---@param buf number The buffer number to retreive the variable for.
    ---@param loclist table The loclist array to report as diagnostics.
    ---@return nil
    send = function(buf, loclist)
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
    end,
  }
end

package.preload['ale.diagnostics'] = M.ale

return M
