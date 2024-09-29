" keymaps for plugins
if exists('g:loaded_ale')
  nnoremap <leader>ai :ALEInfo<CR>
  nnoremap <leader>af :ALEFix<CR>
  nnoremap <leader>al :ALELint<CR>
  nnoremap <leader>an :ALENext<CR>
  nnoremap <leader>ap :ALEPrevious<CR>
  nnoremap <leader>aq :ALEDetail<CR>
  nnoremap <leader>ad :ALEGoToDefinition<CR>
  nnoremap <leader>ar :ALEFindReferences<CR> 
endif

let g:copilot_no_tab_map = v:true
let g:ycm_key_list_select_completion = ['<C-l>']
let g:ycm_key_list_previous_completion = ['<C-k>']
imap <silent><script><expr> <c-j> copilot#Accept("\<C-l>")

" Use Ultisnips default mappings
if exists('g:loaded_ultisnips')
  " inoremap <c-x><c-k> <c-x><c-k>
  let g:UltiSnipsExpandTrigger='<space>'
  let g:UltiSnipsJumpForwardTrigger  ='<tab>'
  " let g:UltiSnipsExpandOrJumpTrigger ='<tab>'
" let g:UltiSnipsJumpOrExpandTrigger =
" let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" let g:UltiSnipsListSnippets="<c-tab>"
endif
