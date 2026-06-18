scriptencoding utf-8

nnoremap <leader>ai <Cmd>ALEInfo<CR>
nnoremap <leader>af <Cmd>ALEFix<CR>

" `:ALEReset`       - `<Plug>(ale_reset)`
" `:ALEResetBuffer` - `<Plug>(ale_reset_buffer)`

" ALEDetail
" ALEFileRename
" ALEFixSuggest
" ALEImport
" ALEOrganizeImports
" ALEPopulateLocList
" ALEPopulateQuickfix
" ALERepeatSelection
" ALESymbolSearch

" " TODO: bracket mappings
" ALELast
" ALEFirst
" ALENextWrap
" ALENext
" ALEPrevious
" ALEPreviousWrap

if has('nvim')
  finish
endif
" match nvim lsp-defaults
nnoremap gra <Cmd>ALECodeAction<CR>
nnoremap gri <Cmd>ALEGoToImplementation<CR>
nnoremap grn <Cmd>ALERename<CR>
nnoremap grr <Cmd>ALEFindReferences<CR>
nnoremap grt <Cmd>ALEGoToTypeDefinition<CR>
" set omnifunc=ale#completion#OmniFunc
" ALEGoToDefinition
" ALEHover

hi clear ALEErrorSign
hi clear ALEWarningSign

let g:ale_sign_error   = '🔥'
let g:ale_sign_warning = '💩'
let g:ale_floating_window_border =
      \ ['│', '─', '╭', '╮', '╯', '╰', '│', '─']

" au BufRead,BufNewFile */.github/*/*.y{,a}ml let b:ale_linters = {'yaml': ['actionlint']}
