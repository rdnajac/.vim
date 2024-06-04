" Enable ALE for linting
let g:ale_enabled = 1

finis
" TODO make ft-specific
" let g:ale_fix_on_save = 1

let g:ale_completion_enabled = 1
" Configure linters for Python
let g:ale_linters = {
\   'python': ['flake8', 'pylint', 'mypy'],
\   'sh': ['shellcheck']
\}

" Configure fixers for Python
let g:ale_fixers = {
\   'python': ['autopep8', 'yapf', 'isort'],
\   'sh': ['shfmt']
\}

" Enable fixing on save

" Python linter and fixer settings
let g:ale_python_flake8_options = '--max-line-length=88'
let g:ale_python_pylint_options = '--max-line-length=88'
let g:ale_python_mypy_options = '--ignore-missing-imports'
let g:ale_python_autopep8_options = '--max-line-length=88'
let g:ale_python_yapf_options = '--style pep8'
let g:ale_python_isort_options = '--profile black'

" Shell linter and fixer settings
let g:ale_sh_shellcheck_options = '-e SC1117'
let g:ale_sh_shfmt_options = '-i 4 -ci -sr'

" Set ALE to use virtual text for displaying linting errors
let g:ale_virtualtext_cursor = 'disabled'
let g:ale_virtualtext_cursor = 'current'

" Customize signs
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'

" Always show the sign column
let g:ale_sign_column_always = 1

" Enable linting only on save and open
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
