" set omnifunc=ale#completion#OmniFunc
let g:ale_disable_lsp = has('nvim')
let g:ale_echo_cursor = 'never'
let g:ale_fixers = {
      \ '*'	  : ['remove_trailing_lines', 'trim_whitespace'],
      \ 'python'  : ['ruff'],
      \ 'markdown': ['rumdl'],
      \ 'lua'     : ['stylua'],
      \ }

let g:ale_lint_on_text_changed = 'never'
let g:ale_linters_explicit = 1
let g:ale_linters = {
      \ 'vim' : ['vint'],
      \ }

let g:ale_virtualtext_cursor = 0

" au BufRead,BufNewFile */.github/*/*.y{,a}ml let b:ale_linters = {'yaml': ['actionlint']}
