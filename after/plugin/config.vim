" .vim/after/plugin/config.vim
" configurations for vim packages
" netrw {{{
" configure the appearance of netrw so that it looks like
" a project drawer but don't try clicking on anything!
let g:netrw_liststyle =  3
let g:netrw_winsize = 25
let g:netrw_list_hide = netrw_gitignore#Hide()
let g:netrw_list_hide .= ',\(^\|\s\s\)\zs\.\S\+'
" unmap shortcut to NetrwBrowseX
xunmap gx
nunmap gx
nnoremap <silent> <leader>` :Lexplore<CR>
" add tpope's vim-vinegar plugin
packadd vim-vinegar
" it helps to be explicit about what is being loaded
" }}}

let g:copilot_workspace_folders = ["~/.vim", "~/.files", "~/cbmf"]
" let g:copilot_no_tab_map = v:true
" imap <silent><script><expr> <C-@> copilot#Accept("")

" vimcomplete and autosuggest
" packadd vimcomplete 
" packadd vim-vsnip
" packadd vim-vsnip-integ

" ALE "{{{
" let g:ale_disable_lsp = 1
let g:ale_completion_enabled = 0
"set omnifunc=ale#completion#OmniFunc
let g:ale_linters_explicit = 1
let g:ale_linters = { 'sh': ['shellcheck'], 'markdown': ['markdownlint', 'marksman'], 'python': ['ruff'], 'vim': ['vint'], }
let g:ale_fixers_explicit = 1
let g:ale_fixers = { 'markdown': ['prettier', 'remove_trailing_lines', 'trim_whitespace'], 'sh': ['shfmt', 'shellharden', 'remove_trailing_lines', 'trim_whitespace'], }
" ALE interface {{{
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
" }}}
" ALE statusline {{{
" https://github.com/dense-analysis/ale?tab=readme-ov-file#custom-statusline
function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? 'OK' : printf(' %dW %dE', l:non_errors, l:all_errors)
endfunction
" set statusline=%{LinterStatus()w  w}
" }}}
" ALE keymaps {{{
nnoremap <leader>ai :ALEInfo<CR>
nnoremap <leader>af :ALEFix<CR>
nnoremap <leader>al :ALELint<CR>
nnoremap <leader>an :ALENext<CR>
nnoremap <leader>ap :ALEPrevious<CR>
nnoremap <leader>aq :ALEDetail<CR>
nnoremap <leader>ad :ALEGoToDefinition<CR>
nnoremap <leader>ar :ALEFindReferences<CR>
" }}}
" }}}
" vim: fdm=marker
