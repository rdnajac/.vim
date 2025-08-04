command! Autocmds lua Snacks.picker.autocmds()
command! Explorer lua Snacks.picker.explorer()
command! Help lua Snacks.picker.help()
command! Highlights lua Snacks.picker.highlights()
command! Lazygit lua Snacks.Lazygit()
command! Terminal lua Snacks.terminal.open()

nnoremap <leader>fc <Cmd>Config<CR>
nnoremap <leader>fc <Cmd>lua Snacks.picker.config()<CR>
nnoremap <leader>fb <Cmd>lua Snacks.picker.buffers()<CR>
nnoremap <leader>fB <Cmd>lua Snacks.picker.buffers({ hidden = true, nofile = true })<CR>

" Buffer Lines
nnoremap <leader>sb <Cmd>lua Snacks.picker.lines()<CR>
nnoremap <leader>sB <Cmd>lua Snacks.picker.grep_buffers()<CR>

" Zen Mode
nnoremap <leader>uz <Cmd>lua Snacks.zen()<CR>
