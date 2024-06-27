" The commands in this file will be executed last.
" Keymaps for plugins are included here.

" Copilot
let g:copilot_workspace_folders = ["~"]
" let g:copilot_no_tab_map = v:true

" Which-key
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

let g:which_key_map = {}

" UltiSnips
let g:UltiSnipsExpandOrJumpTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"
let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']

" ALE completion 
let g:ale_completion_enabled = 0
"set omnifunc=ale#completion#OmniFunc

" ALE interface
let g:ale_disable_lsp = 1
hi clear ALEErrorSign
hi clear ALEWarningSign
let g:ale_sign_error = '💩'
let g:ale_sign_warning = '⚠️'
let g:ale_echo_msg_error_str = '💩'
let g:ale_echo_msg_warning_str = '👾'
" let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" let g:ale_floating_window_border = []
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
" let g:ale_floating_window_border = repeat([''], 8)

" ALE linters
let g:ale_linters_explicit = 1
let g:ale_linters = {
      \ 'sh': ['shellcheck'],
      \ 'markdown': ['markdownlint', 'marksman'],
      \ 'python': ['ruff'],
      \ 'vim': ['vint'],
      \ }

" ALE fixers
let g:ale_fixers_explicit = 1
let g:ale_fixers = {
  \ 'markdown': ['prettier', 'remove_trailing_lines', 'trim_whitespace'],
  \ 'sh': ['shfmt', 'shellharden', 'remove_trailing_lines', 'trim_whitespace'],
  \ }

" ALE keymaps (prefix: <leader>a)
nnoremap <leader>af :ALEFix<CR>
nnoremap <leader>al :ALELint<CR>
nnoremap <leader>an :ALENext<CR>
nnoremap <leader>ap :ALEPrevious<CR>
nnoremap <leader>aq :ALEDetail<CR>
nnoremap <leader>ad :ALEGoToDefinition<CR>
nnoremap <leader>ar :ALEFindReferences<CR>

" LSP (prefix: <leader>l)
nnoremap <leader>lc :LspCodeAction<CR> 
nnoremap <leader>ld :LspDiag current<CR>
nnoremap <leader>lf :LspFold<CR>
nnoremap <leader>lg :LspGotoDeclaration<CR>
nnoremap <leader>lh :LspHover<CR>
nnoremap <leader>li :LspGotoImpl<CR>
nnoremap <leader>lo :LspOutline<CR>



" reset the map v
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
"
" https://github.com/dense-analysis/ale?tab=readme-ov-file#custom-statusline
function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? 'OK' : printf(' %dW %dE', l:non_errors, l:all_errors)
endfunction
" set statusline=%{LinterStatus()w  w}

" Add shellharden as a fixer
function! ShellHarden(buffer) abort
  let command = 'cat ' . a:buffer . " | shellharden --transform ''"
  return { 'command': command }
endfunction
execute ale#fix#registry#Add('shellharden', 'ShellHarden', ['sh'], 'Double quote everything!')

" a note on cspell
" https://github.com/streetsidesoftware/cspell-dicts/tree/main/dictionaries

" netrw settings
let g:netrw_liststyle =  3
let g:netrw_winsize = 25

" Don't show ignored or hidden files in netrw
let g:netrw_list_hide = netrw_gitignore#Hide()
let g:netrw_list_hide .= ',\(^\|\s\s\)\zs\.\S\+'
