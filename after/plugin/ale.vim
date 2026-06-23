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
"

" sh formatting:
" let s:shfmt_flags = '-bn -sr'
" if executable('shfmt')
"   let s:cmd = join(['shfmt', s:shfmt_flags, '--simplify'], ' ')
"   if executable('shellharden')
"     let s:cmd = 'shellharden --transform "" | ' . s:cmd
"   endif
"   let &l:formatprg = s:cmd
" endif
"
" let b:ale_sh_shfmt_options = s:shfmt_flags
" function! ShellHarden(buffer) abort
"   let command = 'cat ' . a:buffer . " | shellharden --transform ''"
"   return { 'command': command }
" endfunction
" execute ale#fix#registry#Add('shellharden', 'ShellHarden', ['sh'], 'Double quote everything!')
