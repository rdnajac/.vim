vim.cmd([[
" vim commands for Snacks functions
  command! ToggleTerm lua Snacks.terminal.toggle()
  command! Chezmoi lua require('munchies.picker.chezmoi')()
  command! Scripts lua require('munchies.picker.scriptnames')()
  command! PluginGrep lua require('munchies.picker.plugins').grep()
  command! PluginFiles lua require('munchies.picker.plugins').files()
  command! -bang Zoxide lua require('munchies.picker.zoxide').pick('<bang>')

  command! Lazygit :lua Snacks.Lazygit()

  cnoreabbrev <expr> Snacks getcmdtype() == ':' && getcmdline() =~ '^Snacks' ? 'lua Snacks' : 'Snacks'
  cnoreabbrev <expr> snacks getcmdtype() == ':' && getcmdline() =~ '^snacks' ? 'lua Snacks' : 'snacks'
]])
