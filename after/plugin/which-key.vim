" https://github.com/liuchengxu/vim-which-key?tab=readme-ov-file#usage
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

let g:which_key_map = {}

" let g:which_key_map['w'] = {
"             \ 'name': '+windows',
"             \ 'w': ['<C-W>w', 'other-window'],
"             \ 'd': ['<C-W>c', 'delete-window'],
"             \ '-': ['<C-W>s', 'split-window-below'],
"             \ '|': ['<C-W>v', 'split-window-right'],
"             \ '2': ['<C-W>v', 'layout-double-columns'],
"             \ 'h': ['<C-W>h', 'window-left'],
"             \ 'j': ['<C-W>j', 'window-below'],
"             \ 'l': ['<C-W>l', 'window-right'],
"             \ 'k': ['<C-W>k', 'window-up'],
"             \ 'H': ['<C-W>5<', 'expand-window-left'],
"             \ 'J': [':resize +5', 'expand-window-below'],
"             \ 'L': ['<C-W>5>', 'expand-window-right'],
"             \ 'K': [':resize -5', 'expand-window-up'],
"             \ '=': ['<C-W>=', 'balance-window'],
"             \ 's': ['<C-W>s', 'split-window-below'],
"             \ 'v': ['<C-W>v', 'split-window-below'],
"             \ '?': ['Windows', 'fzf-window']
"             \ }

let g:which_key_map['a'] = {
            \ 'name': '+ALE',
            \ 'l': ['<Plug>(ale_lint)', 'lint'],
            \ 'f': ['<Plug>(ale_fix)', 'fix'],
            \ 'i': ['<Plug>(ale_info)', 'info'],
            \ 'd': [':ALEDetail<CR>', 'detail'],
            \ 'h': [':ALEHover<CR>', 'hover'],
            \ }
call which_key#register('<Space>', 'g:which_key_map')

" let g:which_key_map['c'] = {
"             \ 'name': '+Copilot',
"             \ 'd': [':Copilot disable<CR>', 'disable'],
"             \ 'e': [':Copilot enable<CR>', 'enable'],
"             \ 's': [':Copilot status<CR>', 'status'],
"             \ 'p': [':Copilot panel<CR>', 'panel'],
"             \ }

" let g:which_key_map['l'] = {
"             \ 'name' : '+LSP' ,
"             \ 'a' : [':LspCodeAction<CR>' , 'code action'] ,
"             \ 'c' : [':LspCodeLens<CR>'   , 'code lens'] ,
"             \ 'd' : [':LspDiag current<CR>', 'current diag'] ,
"             \ 'f' : [':LspFold<CR>'       , 'fold'] ,
"             \ 'g' : [':LspGotoDeclaration<CR>', 'goto declaration'] ,
"             \ 'h' : [':LspHover<CR>'      , 'hover'] ,
"             \ 'i' : [':LspGotoImpl<CR>'   , 'goto impl'] ,
"             \ 'o' : [':LspOutline<CR>'    , 'outline'] ,
"             \ 'r' : [':LspRename<CR>'     , 'rename'] ,
"             \ 's' : [':LspShowReferences<CR>', 'show references'] ,
"             \ 't' : [':LspGotoTypeDef<CR>' , 'goto type def'] ,
"             \ }
" call which_key#register('<Space>', 'g:which_key_map')
