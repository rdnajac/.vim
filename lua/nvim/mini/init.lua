local M = {
  'nvim-mini/mini.nvim',
  lazydev = {},
}

local has_mini_lib = vim.uv.fs_stat(vim.env.PACKDIR .. '/mini.nvim')
if has_mini_lib then
  vim.cmd.packadd('mini.nvim')
  M.lazydev = { { path = 'mini.nvim', words = { 'Mini.*' } } }
end

for k, v in pairs(require('nvim.mini.opts')) do
  local minimod = 'mini.' .. k
  local opts = vim.is_callable(v) and v() or v
  if not has_mini_lib then
    vim.pack.add({ 'https://github.com/nvim-mini/' .. minimod .. '.git' })
    table.insert(M.lazydev, { path = minimod, words = { 'Mini' .. k:gsub('^%l', string.upper) } })
  end
  require(minimod).setup(opts)
end

return M
