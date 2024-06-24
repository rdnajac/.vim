" Set global ALE configuration here (including all linters and fixers)
" Then, set buffer-local configuration in ftplugin files.
" https://github.com/dense-analysis/ale/blob/master/doc/ale.txt

" Disable lsp after setting up yegappan/lsp
" let g:ale_disable_lsp = 1

let g:ale_linters_explicit = 1

let g:ale_sign_error = '💩'
let g:ale_sign_warning = '⚠️'
hi clear ALEErrorSign
hi clear ALEWarningSign

let g:ale_fixers = ['remove_trailing_lines', 'trim_whitespace']

" let g:ale_echo_msg_error_str = 'E'
" let g:ale_echo_msg_warning_str = 'W'
" let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" let g:ale_floating_window_border = []
" let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
" let g:ale_floating_window_border = repeat([''], 8)

" https://github.com/dense-analysis/ale?tab=readme-ov-file#custom-statusline
function! LinterStatus() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors

  return l:counts.total == 0 ? 'OK' : printf(' %dW %dE', l:all_non_errors, l:all_errors)
endfunction
" set statusline=%{LinterStatus()}

" Add shellharden as a fixer
function! ShellHarden(buffer) abort
  let command = 'cat ' . a:buffer . " | shellharden --transform ''"
  return { 'command': command }
endfunction
execute ale#fix#registry#Add('shellharden', 'ShellHarden', ['sh'], 'Double quote everything!')

" a note on cspell
" https://github.com/streetsidesoftware/cspell-dicts/tree/main/dictionaries

" TODO: set this globally and delete references in ftplugins
" let g:ale_fixers = {
" \   '*': ['remove_trailing_lines', 'trim_whitespace'],
" \   'javascript': ['eslint'],
" \}
"
" let g:ale_linters = {
" \   'javascript': ['eslint'],
" \}
