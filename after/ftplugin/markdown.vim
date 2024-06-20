" compile markdown preview
" :call mkdp#util#install()
let g:mkdp_page_title = '${name}'
nnoremap <leader>md :MarkdownPreview<cr>
nnoremap <leader>st i~~<Esc>A~~<Esc>

hi Title     guifg=#14afff guibg=#000000 gui=bold
hi Delimiter guifg=#ff14af guibg=#000000 gui=bold
hi Normal    guifg=#39ff14 guibg=#000000
hi! link Constant Underlined

" ALE
let b:ale_linters = ['markdownlint', 'cspell', 'write-good']
let b:ale_fixers = ['prettier']
let b:ale_fix_on_save = 1

let g:vim_markdown_math = 1
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_fenced_languages = ['bash', 'python', 'php', 'html', 'c', 'cpp', 'sql', 'vim', 'plaintext', 'markdown']
" vim: wrap
