local M = {}

if not package.loaded['lazy'] then
  local this_dir = vim.fs.dirname(debug.getinfo(1, 'S').source:sub(2))
  local files = vim.fn.globpath(this_dir, '*', false, true)

  M.spec = vim
    .iter(files)
    :filter(function(f) return not vim.endswith(f, 'init.lua') end)
    :map(dofile)
    :map(function(t) return vim.islist(t) and t or { t } end)
    :flatten()
    :totable()
end

return M
