#!/usr/bin/env -S NVIM_APPNAME=.vim/repro nvim -u
local root = vim.fn.expand('~/.vim/repro')

for _, d in ipairs({ 'config', 'data', 'state', 'cache' }) do
  local var = ('XDG_%s_HOME'):format(d:upper())
  vim.env[var] = vim.fs.joinpath(root, d)
  print(vim.env[var])
end

local specs = {
  -- 'neovim/neovim',
  'tani/vim-jetpack'
}
-- print(specs)

local function gh(user_repo)
  return 'https://github.com/' .. user_repo .. '.git'
end

local plugs = vim.tbl_map(gh, specs)
-- print(plugs)

-- vim.pack.add(plugs, { confirm = true, load = false })
vim.pack.add(plugs)

-- local specs = {
--   'folke/tokyonight.nvim',
--   'folke/snacks.nvim',
-- }
-- -- info(vim.tbl_map(gh, specs))
-- vim.pack.add(, { confirm = false })
--
-- vim.cmd([[
--   color tokyonight
-- ]])
