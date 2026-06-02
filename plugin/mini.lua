local has_lib = vim.uv.fs_stat(vim.env.PACKDIR .. '/mini.nvim')
local lazydev = has_lib and { { path = 'mini.nvim', words = { 'Mini.*' } } } or {}

for k, v in pairs(require('nvim.mini.opts')) do
  local minimod = 'mini.' .. k
  local opts = vim.is_callable(v) and v() or v
  if not has_lib then
    vim.pack.add({ ('https://github.com/nvim-mini/%s.git'):format(minimod) })
    table.insert(lazydev, { path = minimod, words = { 'Mini' .. k:gsub('^%l', string.upper) } })
  end
  require(minimod).setup(opts)
end

nv.mini = { lazydev = lazydev }
