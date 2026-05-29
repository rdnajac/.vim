local M = {}

M.keywords = {
  Fixme = { 'BUG', 'FIX', 'FIXME' },
  Hack = { 'HACK', 'WARN', 'XXX' },
  Todo = { 'TODO', 'INFO' },
  Note = { 'NOTE', 'Section' },
}

-- Snacks.util.set_hl({
--   Fixme = 'Chromatophore',
--   Hack = 'Chromatophore',
--   Todo = 'Chromatophore',
--   Note = 'Chromatophore',
-- }, { prefix = 'MiniHipatterns', default = true })

M.lookup = vim.iter(M.keywords):fold({}, function(acc, k, v)
  for _, kw in ipairs(v) do
    acc[kw] = k
  end
  return acc
end)

M.mini = vim.iter(M.keywords):fold({}, function(acc, k, v)
  acc[k] = { pattern = v, group = 'MiniHipatterns' .. k }
  return acc
end)

-- `vim.diagnostic.severity` = { ERROR = 1, WARN = 2, INFO = 3, HINT = 4 }
M.minimap = { Fixme = 'Error', Hack = 'Warn', Todo = 'Info', Note = 'Hint' }
-- NOTE: mini.hipatterns sets the default to inverted diagnostic group

M.icon = function(keyword)
  local v = M.minimap[M.lookup[keyword]]
  if v then
    return { nv.ui.icons.diagnostics[v], 'Diagnostic' .. v }
  end
end

return M
