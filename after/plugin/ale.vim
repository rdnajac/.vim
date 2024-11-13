scriptencoding utf-8

" if ale isn't installed, don't load this file
if !exists('g:loaded_ale')
  finish
endif

" ALE settings {{{1
let g:ale_disable_lsp = 1
let g:ale_completion_enabled = 0
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
let g:ale_virtualtext_cursor = 1

" linting {{{2
let g:ale_linters_explicit = 1
let g:ale_linters = {
      \ 'sh'	  : ['shellcheck', 'cspell'],
      \ 'markdown': ['markdownlint', 'cspell'],
      \ 'python'  : ['ruff'],
      \ 'vim'	  : ['vint'],
      \ }

let g:ale_sign_error   = '🔥'
hi clear ALEErrorSign
let g:ale_sign_warning = '💩'
hi clear ALEWarningSign

" formatting {{{2
let g:ale_fix_on_save = 1
let g:ale_fixers_explicit = 1
let g:ale_fixers = {
      \ '*'	  : ['remove_trailing_lines', 'trim_whitespace'],
      \ 'markdown': ['prettier'],
      \ 'python'  : ['ruff_format'],
      \ 'sh'	  : ['shfmt','shellharden'],
      \ }

" sh {{{3
let g:ale_sh_shfmt_options = '-bn -sr'

function! ShellHarden(buffer) abort
  let command = 'cat ' . a:buffer . " | shellharden --transform ''"
  return { 'command': command }
endfunction
execute ale#fix#registry#Add('shellharden', 'ShellHarden', ['sh'], 'Double quote everything!')
" }}}3

" keymaps {{{2
nnoremap <leader>ai :ALEInfo<CR>
nnoremap <leader>af :ALEFix<CR>
nnoremap <leader>al :ALELint<CR>
nnoremap <leader>an :ALENext<CR>
nnoremap <leader>ap :ALEPrevious<CR>
nnoremap <leader>aq :ALEDetail<CR>
nnoremap <leader>ad :ALEGoToDefinition<CR>
nnoremap <leader>ar :ALEFindReferences<CR>

" ALE statusline {{{2
" https://github.com/dense-analysis/ale?tab=readme-ov-file#custom-statusline
function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? 'OK' : printf(' %dW %dE', l:non_errors, l:all_errors)
endfunction
" set statusline=%{LinterStatus()w  w}
" }}}
