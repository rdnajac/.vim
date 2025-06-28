vim.cmd([[
" vim commands for Snacks functions
command! Explorer lua Snacks.picker.explorer({cwd = vim.cmd.pwd()})
command! Keymaps lua Snacks.picker.keymaps()
command! Highlights lua Snacks.picker.highlights()
command! Terminal lua Snacks.terminal.toggle()
command! Chezmoi lua require('lazy.spec.snacks.picker.chezmoi')()
command! Scripts lua require('lazy.spec.snacks.picker.scriptnames')()
command! PluginGrep lua require('lazy.spec.snacks.picker.plugins').grep()
command! PluginFiles lua require('lazy.spec.snacks.picker.plugins').files()
command! -bang Zoxide lua require('lazy.spec.snacks.picker.zoxide').pick('<bang>')
command! Help lua Snacks.picker.help()
command! Lazygit :lua Snacks.Lazygit()
command! Config :lua Snacks.picker.files({cwd =vim.fn.stdpath('config')})
command! -bang Scratch execute 'lua require("snacks").scratch' . (<bang>0 ? '.select' : '') .. '()'
command! Autocmds lua Snacks.picker.autocmds()
]])

vim.api.nvim_create_user_command('Autocmds', function()
  Snacks.picker.autocmds()
end, {})
