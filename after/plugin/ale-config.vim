" Set global ALE configuration here (including all linters and fixers) 
" Then, set buffer-local configuration in ftplugin files.
" https://github.com/dense-analysis/ale/blob/master/doc/ale.txt

" turn this off in python.vim
"let g:ale_use_global_executables = 1

" https://github.com/streetsidesoftware/cspell-dicts/tree/main/dictionaries
let g:ale_linters = {
            \'vim': ['vint'],
            \'python': [],
            \}

let g:ale_fixers = {
            \'*': ['remove_trailing_lines', 'trim_whitespace'],
            \'vim': ['vint'],
            \'python': [],
            \}

let g:ale_sign_error = '💩'
let g:ale_sign_warning = '💩'
hi clear ALEErrorSign
hi clear ALEWarningSign
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

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction
" optionally, set the statusline to use the function
" set statusline=%{LinterStatus()}
