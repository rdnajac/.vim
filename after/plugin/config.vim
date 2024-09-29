" Configs for plugins
scriptencoding utf-8
let g:copilot_workspace_folders = ["~/.vim", "~/.files", "~/rdnajac"]

let g:ale_disable_lsp	      = 1
let g:ale_completion_enabled  = 0
let g:ale_linters_explicit    = 1
let g:ale_linters = { 
      \ 'dockerfile': ['hadolint'],
      \ 'sh'      : ['shellcheck', 'cspell', ], 
      \ 'markdown': ['markdownlint', 'marksman', 'cspell'], 
      \ 'python'  : ['ruff'], 
      \ 'vim'     : ['vint'], 
      \ }

" ignore md013 line length
let g:ale_markdown_markdownlint_options = '--disable MD013'

let g:ale_fixers = { 
      \ 'dockerfile': ['dprint'],
      \ 'markdown': ['remove_trailing_lines', 'trim_whitespace', 'prettier'], 
      \ 'sh'      : ['remove_trailing_lines', 'trim_whitespace'], 
      \ }

hi clear ALEErrorSign
hi clear ALEWarningSign
let g:ale_sign_error = '💩'
let g:ale_sign_warning = '🔥'
" let g:ale_virtualtext_prefix = ''
let g:ale_virtualtext_cursor = 'current'
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']

let g:ycm_semantic_triggers = {
      \ 'c' : ['->', '.'],
      \ 'cpp' : ['->', '.', '::'],
      \ 'python' : ['.'],
      \ }

let g:ycm_complete_in_comments_and_strings = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_error_symbol = '🔥'
let g:ycm_warning_symbol = '💩'
let g:ycm_enable_diagnostic_signs = 1
" let g:ycm_show_diagnostics_ui=0
let g:ycm_auto_hover = ''
nmap ? <plug>(YCMHover)
" set completeopt-=preview

let s:popup_options = {
      \ 'border': [1, 1, 1, 1],
      \ 'borderhighlight': ['String'],
      \ 'borderchars': ['─', '│', '─', '│', '╭', '╮', '╯', '╰'],
      \ }

augroup MyYCMCustom
  autocmd!
  autocmd FileType * let b:ycm_hover = {
        \ 'command': 'GetDoc',
        \ 'syntax': &filetype,
        \ 'popup_params': s:popup_options
        \ }
augroup END

" Clear existing YCM highlight groups
hi clear YcmErrorSign
hi clear YcmWarningSign
hi clear YcmErrorLine
hi clear YcmWarningLine
hi clear YcmErrorSignLineNr
hi clear YcmWarningSignLineNr
