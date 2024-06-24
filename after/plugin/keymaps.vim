" Settings for which-key, YouCompleteMe, UltiSnips, and ALE
" UltiSnips
let g:UltiSnipsExpandOrJumpTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']


" Which-key
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

" reset the map
"let g:which_key_map = {}
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
