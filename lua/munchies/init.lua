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
--
-- local function fu(lhs, fn, desc, mode)
--   -- print the function name
--   local fname =
--   return { lhs, function() fn() end, desc = desc, mode = mode, }
-- end
--
--   local a = fu(',,', Snacks.terminal.toggle, 'Snacks Terminal', { 'n', 't' })
--   local b = fu('<leader>.', Snacks.scratch, 'Toggle Scratch Buffer')
--   local c = fu('<leader>>', Snacks.scratch.select, 'Select Scratch Buffer')
--
--   print(a)
