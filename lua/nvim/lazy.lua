vim.cmd([[
au InsertEnter * lua require('blink.cmp').setup(require('lazy.spec.blink').opts())
au InsertEnter * lua require('lazy.spec.dial')
]])
