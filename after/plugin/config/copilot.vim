let g:copilot_workspace_folders = [ '~/GitHub', '~/.local/share/chezmoi/' ]
" let g:copilot_no_maps = v:true
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <S-Tab> copilot#Accept("\<CR>")

finish
augroup CopilotSuggestion
  autocmd!
  autocmd User BlinkCmpMenuOpen call copilot#Dismiss() | let b:copilot_suggestion_hidden = v:true
  autocmd User BlinkCmpMenuClose let b:copilot_suggestion_hidden = v:false
augroup END
