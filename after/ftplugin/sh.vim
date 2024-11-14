" after/ftplugin/sh.vim

" setlocal iskeyword+=-

" force bash for sh files when using eunuch
" so that typing `#!` at the top of a file will default to /bin/bash
let g:eunuch_interpreters = { 'sh': '/bin/bash' }

inoreabbrev safe set -euo pipefail<CR>IFS=$'\n\t'<CR>
