#!/usr/bin/env -S NVIM_APPNAME=.repro nvim -u

local root = vim.fn.expand('~/.repro')
-- set stdpaths to use  a temporary directory
for _, name in ipairs({ 'config', 'data', 'state', 'cache' }) do
  vim.env[('XDG_%s_HOME'):format(name:upper())] = root .. '/' .. name
end

local specs = {
  -- 'neovim/neovim',
  'tani/vim-jetpack',
}

local function gh(user_repo) return 'https://github.com/' .. user_repo .. '.git' end

local plugs = vim.tbl_map(gh, specs)
vim.o.cmdheight = 0
require('vim._extui').enable({})
vim.pack.add(plugs)
