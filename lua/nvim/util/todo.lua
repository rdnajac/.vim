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

-- Mini sets the default highlight to inverted color of the Diagnostic group
-- local minimap = { Fixme = 'Error', Hack = 'Warn', Todo = 'Info', Note = 'Hint' }

-- Flat lookup: keyword string → group name (e.g. BUG → Fixme)
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

-- Maps group name → diagnostic severity (for icons/highlights)
M.minimap = { Fixme = 'Error', Hack = 'Warn', Todo = 'Info', Note = 'Hint' }

M.icon = function(keyword)
  local v = M.minimap[M.lookup[keyword]]
  if v then
    return { nv.ui.icons.diagnostics[v], 'Diagnostic' .. v }
  end
end

return M
