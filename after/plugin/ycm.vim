let g:ycm_semantic_triggers = {
      \ 'c' : ['->', '.'],
      \ 'python' : ['.'],
      \ }

let g:ycm_complete_in_comments_and_strings = 1
" let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
" let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_error_symbol = '🔥'
let g:ycm_warning_symbol = '💩'
let g:ycm_enable_diagnostic_signs = 1
" let g:ycm_show_diagnostics_ui=0
let g:ycm_auto_hover = ''

" set completeopt-=preview

nmap ? <plug>(YCMHover)

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


