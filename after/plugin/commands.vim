command! Chezmoi     :lua require('munchies.picker').chezmoi()
command! Scriptnames :lua require('munchies.picker').scriptnames()

" TODO: vim.api.nvim_create_autocmd('CmdlineEnter', {
cnoreabbrev <expr> Snacks getcmdtype() == ':' && getcmdline() =~ '^Snacks' ? 'lua Snacks' : 'Snacks'
cnoreabbrev <expr> snacks getcmdtype() == ':' && getcmdline() =~ '^snacks' ? 'lua Snacks' : 'snacks'
