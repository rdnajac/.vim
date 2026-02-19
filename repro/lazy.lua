vim.env.LAZY_STDPATH = vim.fn.expand('~/.lazyrepro')
load(vim.fn.system('curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua'))()

local plugins = {
  {
    'folke/snacks.nvim',
  },
  opts = {},
}

require('lazy.minit').repro({ spec = plugins })
