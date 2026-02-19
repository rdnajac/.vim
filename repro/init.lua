#!/usr/bin/env -S NVIM_APPNAME=.repro nvim -u NORC -S

local root = vim.fn.expand('~/.repro')
-- set stdpaths to use  a temporary directory
for _, name in ipairs({ 'config', 'data', 'state', 'cache' }) do
  vim.env[('XDG_%s_HOME'):format(name:upper())] = root .. '/' .. name
end

local specs = vim.tbl_map(
  function(user_repo) return 'https://github.com/' .. user_repo .. '.git' end,
  {
    -- 'neovim/neovim',
    -- 'tani/vim-jetpack',
    'folke/snacks.nvim',
  }
)

vim.pack.add(specs)

-- vim.o.cmdheight = 0
-- require('vim._core.ui2').enable({})

require('snacks').setup({})

vim.cmd([[
  nmap <leader>e :lua Snacks.explorer()<CR>
]])
