-- collect specs from meta-modules
-- TODO: include mini?
local plugins = vim.iter({ 'blink', 'lazy', 'lsp', 'mini', 'treesitter' }):fold({}, function(acc, name)
  for _, spec in ipairs(require('nvim.' .. name).spec) do
    table.insert(acc, spec)
  end
  return acc
end)

dd(plugins)

if not package.loaded['lazy'] then
  local this_dir = vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))
  local submodules = nv.submodules({ dir = this_dir })
  local iter = vim.iter(submodules)
  local plugins2 = iter:map(require):map(nv.fn.ensure_list):flatten():totable()
  vim.list_extend(plugins, plugins2)
end

return plugins
