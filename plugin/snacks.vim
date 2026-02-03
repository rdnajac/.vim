if !has('nvim')
  finish
endif

command! LazyGit :lua Snacks.lazygit()

nnoremap <leader>, <Cmd>lua Snacks.picker.buffers()<CR>
nnoremap <leader>/ <Cmd>lua Snacks.picker.grep()<CR>
nnoremap <leader>. <Cmd>lua Snacks.scratch()<CR>
nnoremap <leader>> <Cmd>lua Snacks.scratch.select()<CR>

" buffer
nnoremap <leader>bb <Cmd>lua Snacks.picker.buffers()<CR>
nnoremap <leader>bB <Cmd>lua Snacks.picker.buffers({ hidden = true, nofile = true })<CR>
nnoremap <leader>bD <Cmd>lua Snacks.bufdelete.other()<CR>
nnoremap <leader>bd <Cmd>lua Snacks.bufdelete()<CR>
nnoremap <leader>bl <Cmd>lua Snacks.picker.lines()<CR>
nnoremap <leader>bg <Cmd>lua Snacks.picker.grep_buffers()<CR>

" coding
nnoremap <leader>cd <Cmd>lua Snacks.picker.diagnostics()<CR>
nnoremap <leader>cD <Cmd>lua Snacks.picker.diagnostics_buffer()<CR>
nnoremap <leader>cR <Cmd>lua Snacks.rename.rename_file()<CR>

" debug
nnoremap <leader>dpf <Cmd>lua Snacks.profiler.pick({ filter = { def_plugin = vim.fn.input('Filter by plugin: ') } })<CR>
nnoremap <leader>dps <Cmd>lua Snacks.profiler.scratch()<CR>

" explorer
nnoremap <leader>e <Cmd>lua Snacks.explorer.reveal()<CR>
nnoremap <leader>E <Cmd>lua Snacks.explorer.open()<CR>

" Find mappings
nnoremap <leader>F <Cmd>lua Snacks.picker.smart()<CR>
nnoremap <leader>fb <Cmd>lua Snacks.picker.buffers()<CR>
nnoremap <leader>ff <Cmd>lua Snacks.picker.files()<CR>
nnoremap <leader>fg <Cmd>lua Snacks.picker.git_files()<CR>
nnoremap <leader>fP <Cmd>lua Snacks.picker.projects()<CR>
nnoremap <leader>fr <Cmd>lua Snacks.picker.recent()<CR>
nnoremap <leader>fC <Cmd>lua Snacks.rename.rename_file()<CR>

" git
nnoremap <leader>gb <Cmd>lua Snacks.picker.git_branches()<CR>
nnoremap <leader>gd <Cmd>lua Snacks.picker.git_diff()<CR>
nnoremap <leader>gf <Cmd>lua Snacks.picker.git_log_file()<CR>
nnoremap <leader>gg <Cmd>lua Snacks.lazygit()<CR>
nnoremap <leader>gL <Cmd>lua Snacks.picker.git_log_line()<CR>
nnoremap <leader>gl <Cmd>lua Snacks.picker.git_log()<CR>
nnoremap <leader>gs <Cmd>lua Snacks.picker.git_status()<CR>
nnoremap <leader>gS <Cmd>lua Snacks.picker.git_stash()<CR>

" neovim news
nnoremap <leader>N <Cmd>lua Snacks.zen({ win = { file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1] } })<CR>

" notifications
nnoremap <leader>n <Cmd>lua Snacks.notifier.show_history()<CR>

" picker
nnoremap <leader>P <Cmd>lua Snacks.picker.resume({ exclude = { 'pickers' } })<CR>
nnoremap <leader>pP <Cmd>lua Snacks.picker.picker_preview()<CR>
nnoremap <leader>pa <Cmd>lua Snacks.picker.picker_actions()<CR>
nnoremap <leader>pf <Cmd>lua Snacks.picker.picker_format()<CR>
nnoremap <leader>pl <Cmd>lua Snacks.picker.picker_layouts()<CR>
nnoremap <leader>pp <Cmd>lua Snacks.picker.pickers()<CR>
nnoremap <leader>pr <Cmd>lua Snacks.picker.resume()<CR>

" search
nnoremap <leader>sa <Cmd>lua Snacks.picker.autocmds()<CR>
nnoremap <leader>sb <Cmd>lua Snacks.picker.lines()<CR>
nnoremap <leader>sB <Cmd>lua Snacks.picker.grep_buffers()<CR>
nnoremap <leader>sC <Cmd>lua Snacks.picker.commands()<CR>
nnoremap <leader>sg <Cmd>lua Snacks.picker.grep()<CR>
nnoremap <leader>sG <Cmd>lua Snacks.picker.git_grep()<CR>
nnoremap <leader>sh <Cmd>lua Snacks.picker.help()<CR>
nnoremap <leader>sH <Cmd>lua Snacks.picker.highlights()<CR>
nnoremap <leader>si <Cmd>lua Snacks.picker.icons()<CR>
nnoremap <leader>sj <Cmd>lua Snacks.picker.jumps()<CR>
nnoremap <leader>sk <Cmd>lua Snacks.picker.keymaps()<CR>
nnoremap <leader>sL <Cmd>lua Snacks.picker.loclist()<CR>
nnoremap <leader>sm <Cmd>lua Snacks.picker.marks()<CR>
nnoremap <leader>sM <Cmd>lua Snacks.picker.man()<CR>
nnoremap <leader>sn <Cmd>lua Snacks.picker.notifications()<CR>
nnoremap <leader>sq <Cmd>lua Snacks.picker.qflist()<CR>
nnoremap <leader>sw <Cmd>lua Snacks.picker.grep_word()<CR>
vnoremap <leader>sW viW<Cmd>lua Snacks.picker.grep_word()<CR>
nnoremap <leader>su <Cmd>lua Snacks.picker.undo()<CR>
nnoremap <leader>s" <Cmd>lua Snacks.picker.registers()<CR>
nnoremap <leader>s: <Cmd>lua Snacks.picker.command_history()<CR>
nnoremap <leader>s/ <Cmd>lua Snacks.picker.search_history()<CR>
" lsp
nnoremap <leader>slc <Cmd>lua Snacks.picker.lsp_config()<CR>
nnoremap <leader>sls <Cmd>lua Snacks.picker.lsp_symbols()<CR>
nnoremap <leader>slS <Cmd>lua Snacks.picker.lsp_workspace_symbols()<CR>
nnoremap <leader>sli <Cmd>lua Snacks.picker.lsp_incoming_calls()<CR>
nnoremap <leader>slo <Cmd>lua Snacks.picker.lsp_outgoing_calls()<CR>
nnoremap <leader>sld <Cmd>lua Snacks.picker.lsp_definitions()<CR>
nnoremap <leader>slD <Cmd>lua Snacks.picker.lsp_declarations()<CR>
nnoremap <leader>slR <Cmd>lua Snacks.picker.lsp_references()<CR>
nnoremap <leader>slI <Cmd>lua Snacks.picker.lsp_implementations()<CR>
nnoremap <leader>slT <Cmd>lua Snacks.picker.lsp_type_definitions()<CR>

" ui/utility
nnoremap <leader>uC <Cmd>lua Snacks.picker.colorschemes()<CR>
nnoremap <leader>un <Cmd>lua Snacks.notifier.hide()<CR>
nnoremap <leader>uz <Cmd>lua Snacks.zen()<CR>
nnoremap <leader>z <Cmd>lua Snacks.zen()<CR>
nnoremap <leader>Z <Cmd>lua Snacks.zen.zoom()<CR>

" picker pairs
nnoremap <leader>fe <Cmd>lua Snacks.picker.files({ dirs = vim.api.nvim_list_runtime_paths() })<CR>
nnoremap <leader>se <Cmd>lua Snacks.picker.grep({ dirs = vim.api.nvim_list_runtime_paths() })<CR>

nnoremap <leader>fc <Cmd>lua Snacks.picker.files({ cwd = vim.g.VIMDIR })<CR>
nnoremap <leader>sc <Cmd>lua Snacks.picker.grep({  cwd = vim.g.VIMDIR })<CR>

let s:commands = [
      \ 'Autocmds',
      \ 'Colorschemes',
      \ 'Commands',
      \ 'Files',
      \ 'Grep',
      \ 'Help',
      \ 'Icons',
      \ 'Keymaps',
      \ 'Registers',
      \ 'Spelling',
      \ 'Undo',
      \ 'Zoxide'
      \ ]

  " TODO: use map?
for [_, cmd] in items(s:commands)
  execute printf('command %s :lua Snacks.picker.%s()<CR>', cmd, tolower(cmd))
endfor

finish
let s:commands = [
      \ 'Actions',
      \ 'Buffers',
      \ 'Cliphist',
      \ 'CommandHistory',
      \ 'Diagnostics',
      \ 'DiagnosticsBuffer',
      \ 'Explorer',
      \ 'GhActions',
      \ 'GhDiff',
      \ 'GhIssue',
      \ 'GhLabels',
      \ 'GhPr',
      \ 'GhReactions',
      \ 'GitBranches',
      \ 'GitDiff',
      \ 'GitFiles',
      \ 'GitGrep',
      \ 'GitLog',
      \ 'GitLogFile',
      \ 'GitLogLine',
      \ 'GitStash',
      \ 'GitStatus',
      \ 'GrepBuffers',
      \ 'GrepWord',
      \ 'Highlights',
      \ 'Jumps',
      \ 'Lines',
      \ 'Loclist',
      \ 'LspConfig',
      \ 'LspDeclarations',
      \ 'LspDefinitions',
      \ 'LspImplementations',
      \ 'LspIncomingCalls',
      \ 'LspOutgoingCalls',
      \ 'LspReferences',
      \ 'LspSymbols',
      \ 'LspTypeDefinitions',
      \ 'LspWorkspaceSymbols',
      \ 'Marks',
      \ 'Notifications',
      \ 'Pick',
      \ 'PickerActions',
      \ 'PickerFormat',
      \ 'PickerLayouts',
      \ 'PickerPreview',
      \ 'Pickers',
      \ 'Preview',
      \ 'Projects',
      \ 'Qflist',
      \ 'Recent',
      \ 'Resume',
      \ 'Scratch',
      \ 'SearchHistory',
      \ 'Smart',
      \ 'Tags',
      \ 'Treesitter',
      \]
