package.preload['ale.diagnostics'] = function() return require('nvim.diagnostics.ale') end

vim.schedule(function()
  local icons = nv.ui.icons.diagnostics
  vim.diagnostic.config({
    float = { source = true },
    underline = false,
    virtual_text = false,
    severity_sort = true,
    signs = { text = icons },
    status = {
      format = nv.ui.status.render_counts(icons, {
        'DiagnosticSignError',
        'DiagnosticSignWarn',
        'DiagnosticSignInfo',
        'DiagnosticSignHint',
      }),
    },
  })
end)
