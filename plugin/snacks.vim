if !has('nvim')
  finish
endif

inoremap <silent> ,i <Cmd>Icons<CR>

nnoremap <C-Bslash> <Cmd>lua Snacks.terminal.toggle()<CR>
tnoremap <C-Bslash> <Cmd>lua Snacks.terminal.toggle()<CR>
xnoremap <leader>/ <Cmd>lua Snacks.picker.grep_word<CR>
nnoremap ,, <Cmd>lua Snacks.picker.buffers()<CR>
nnoremap <Home> <Cmd>lua Snacks.dashboard.open()<CR>

nnoremap ,, <Cmd>lua Snacks.picker.buffers()<CR>
nnoremap ,. <Cmd>lua Snacks.scratch()<CR>
nnoremap ,> <Cmd>lua Snacks.scratch.select()<CR>

" buffer
nnoremap <leader>bD <Cmd>lua Snacks.bufdelete.other()<CR>
nnoremap <leader>bd <Cmd>lua Snacks.bufdelete()<CR>

" coding
nnoremap <leader>cR <Cmd>lua Snacks.rename.rename_file()<CR>

" debug
nnoremap <leader>dpf <Cmd>lua Snacks.profiler.pick({ filter = { def_plugin = vim.fn.input('Filter by plugin: ') } })<CR>
nnoremap <leader>dps <Cmd>lua Snacks.profiler.scratch()<CR>

" file
nnoremap <leader>fC <Cmd>lua Snacks.rename.rename_file()<CR>

" explorer
nnoremap <leader>e <Cmd>lua Snacks.explorer.open({cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0))})<CR>
nnoremap <leader>E <Cmd>lua Snacks.explorer.reveal()<CR>

" git
nnoremap <leader>gb <Cmd>lua Snacks.picker.git_branches()<CR>
nnoremap <leader>gd <Cmd>lua Snacks.picker.git_diff()<CR>
nnoremap <leader>gf <Cmd>lua Snacks.picker.git_log_file()<CR>
nnoremap <leader>gg <Cmd>lua Snacks.lazygit()<CR>
nnoremap <leader>gL <Cmd>lua Snacks.picker.git_log_line()<CR>
nnoremap <leader>gl <Cmd>lua Snacks.picker.git_log()<CR>
nnoremap <leader>gs <Cmd>lua Snacks.picker.git_status()<CR>
nnoremap <leader>gS <Cmd>lua Snacks.picker.git_stash()<CR>

" lsp
nnoremap <leader>lc <Cmd>lua Snacks.picker.lsp_config()<CR>
nnoremap <leader>ls <Cmd>lua Snacks.picker.lsp_symbols()<CR>
nnoremap <leader>lS <Cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>
nnoremap <leader>li <Cmd>lua Snacks.picker.lsp_incoming_calls()<CR>
nnoremap <leader>lo <Cmd>lua Snacks.picker.lsp_outgoing_calls()<CR>
nnoremap <leader>ld <Cmd>lua Snacks.picker.lsp_definitions()<CR>
nnoremap <leader>lD <Cmd>lua Snacks.picker.lsp_declarations()<CR>
nnoremap <leader>lR <Cmd>lua Snacks.picker.lsp_references()<CR>
nnoremap <leader>lI <Cmd>lua Snacks.picker.lsp_implementations()<CR>
nnoremap <leader>lT <Cmd>lua Snacks.picker.lsp_type_definitions()<CR>
nnoremap <leader>lW <Cmd>=vim.lsp.buf.list_workspace_folders()<CR>

" ui/utility
nnoremap <leader>uC <Cmd>lua Snacks.picker.colorschemes()<CR>
nnoremap <leader>un <Cmd>lua Snacks.notifier.hide()<CR>
nnoremap <leader>uz <Cmd>lua Snacks.zen()<CR>
nnoremap <leader>z <Cmd>lua Snacks.zen()<CR>
nnoremap <leader>Z <Cmd>lua Snacks.zen.zoom()<CR>

" picker pairs
nnoremap <leader>fe <Cmd>lua Snacks.picker.files({ dirs = vim.api.nvim_list_runtime_paths() })<CR>
nnoremap <leader>se <Cmd>lua Snacks.picker.grep({ dirs = vim.api.nvim_list_runtime_paths() })<CR>

nnoremap <leader>fc <Cmd>lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })<CR>
nnoremap <leader>sc <Cmd>lua Snacks.picker.grep({  cwd = vim.fn.stdpath('config') })<CR>

let s:commands = [
      \ 'Actions',
      \ 'Autocmds',
      \ 'Buffers',
      \ 'Cliphist',
      \ 'Colorschemes',
      \ 'CommandHistory',
      \ 'Commands',
      \ 'Diagnostics',
      \ 'DiagnosticsBuffer',
      \ 'Explorer',
      \ 'Files',
      \ 'Help',
      \ 'Highlights',
      \ 'Icons',
      \ 'Jumps',
      \ 'Keymaps',
      \ 'Lines',
      \ 'Marks',
      \ 'Notifications',
      \ 'Pickers',
      \ 'Projects',
      \ 'Recent',
      \ 'Registers',
      \ 'Spelling',
      \ 'Tags',
      \ 'Treesitter',
      \ 'Undo',
      \ 'Zoxide'
      \]

for [_, cmd] in items(s:commands)
  execute printf('command %s :lua Snacks.picker.%s()<CR>', cmd, tolower(cmd))
endfor
