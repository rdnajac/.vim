vim.cmd([[
" vim commands for Snacks functions
command! Chezmoi :lua require('munchies.picker').chezmoi()
command! Config :lua require('munchies.picker').chezmoi()
" command! Plugins :lua require('munchies.picker').plugins()
command! Scripts :lua require('munchies.picker').scripts()
command! Lazygit :lua Snacks.Lazygit()

cnoreabbrev <expr> Snacks getcmdtype() == ':' && getcmdline() =~ '^Snacks' ? 'lua Snacks' : 'Snacks'
cnoreabbrev <expr> snacks getcmdtype() == ':' && getcmdline() =~ '^snacks' ? 'lua Snacks' : 'snacks'
]])
