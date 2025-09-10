local src = 'https://github.com/folke/edgy.nvim.git'
local name = 'edgy'
local spec = { src = src, name = name }

local specs = vim.tbl_map(function(p)
  return 'http://github.com/'..p..'.git'
end, {
  'tpope/vim-capslock',
  'tpope/vim-characterize',
  'tpope/vim-dispatch'
})
print(specs)
---@module "snacks"
-- Snacks.util.on_module(name, function()
--   require(name).setup({})
--   Snacks.notify.info(name .. ' cb')
-- end)

vim.pack.add({ specs[1] }, {
  load = function(data)
    local spec = data.spec
    local name = spec.name
    local bang = vim.v.vim_did_enter == 0

    vim.cmd.packadd({ name, bang = bang, magic = { file = false } })
    vim.pack.add({specs[2]}, {confirm = false})
    vim.pack.add({specs[3]}, {confirm = false})
  end,
})
