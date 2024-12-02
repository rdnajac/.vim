" after/copilot.vim
if !exists('g:loaded_copilot') || has('nvim')
  finish
endif
let g:copilot_workspace_folders = ['~/.vim', '~/.files', '~/Desktop/rdnajac']
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <c-j> copilot#Accept("\<C-j>")
