dd('lang')
require('mason').setup({})

local ensure_installed = require('nvim.treesitter.parsers')
require('nvim-treesitter').install(ensure_installed)
require('ts-comments').setup({})
require('lang.lazydev')
