vim.cmd([[
" vim commands for Snacks functions
  command! Chezmoi lua require('munchies.picker.chezmoi')()
  command! Scripts lua require('munchies.picker.scriptnames')()
  command! PluginGrep lua require('munchies.picker.plugins').grep()
  command! PluginFiles lua require('munchies.picker.plugins').files()

  command! Lazygit :lua Snacks.Lazygit()

  cnoreabbrev <expr> Snacks getcmdtype() == ':' && getcmdline() =~ '^Snacks' ? 'lua Snacks' : 'Snacks'
  cnoreabbrev <expr> snacks getcmdtype() == ':' && getcmdline() =~ '^snacks' ? 'lua Snacks' : 'snacks'
]])
