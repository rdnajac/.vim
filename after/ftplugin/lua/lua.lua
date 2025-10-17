-- Disable highlighting inside of `vim.cmd([[...]])`
-- Snacks.util.set_hl({ LspReferenceText = { link = 'NONE' } })
-- -- TODO: use `--search-parent-directories` or detect root lua
-- vim.bo.formatprg = 'stylua --stdin-filepath='
--     .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':p')
--     .. ' -f '
--     .. vim.fs.joinpath(vim.fn.stdpath('config'), 'stylua.toml')

-- Keep using legacy syntax for `vim-endwise`
vim.bo.syntax = 'ON'

vim.cmd([[
 setlocal nonumber signcolumn=yes:1
]])

vim.keymap.set('n', 'yu', nv.debug, { desc = 'Debug <cword>' })
