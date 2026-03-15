local hl_map = {
  'DiagnosticSignError',
  'DiagnosticSignWarn',
  'DiagnosticSignInfo',
  'DiagnosticSignHint',
}

local icons = nv.ui.icons.diagnostics

---@type vim.diagnostic.Opts
local opts = {
  float = { source = true },
  underline = false,
  virtual_text = false,
  severity_sort = true,
  signs = {
    text = icons,
  },
  status = {
    format = function(counts)
      return vim
        .iter(ipairs(vim.diagnostic.severity))
        :map(function(i, _) return i, counts[i] or 0 end)
        :filter(function(_, count) return count > 0 end)
        :map(function(i, count) return ('%%#%s#%s %s'):format(hl_map[i], icons[i], count) end)
        :join(' ')
    end,
  },
}

vim.schedule(function() vim.diagnostic.config(opts) end)
