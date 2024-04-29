" vim:ft=vim :wrap
nnoremap <leader>md :MarkdownPreview<cr>
setlocal wrap spell spl=en_us cole=2 fdl=2
let g:vim_markdown_fenced_languages = ['bash=sh', 'python', 'php', 'html', 'c', 'cpp', 'sql', 'vim', 'dockerfile', 'plaintext', 'markdown']
let g:vim_markdown_math = 1

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_folding_style_pythonic = 1

" function! MarkdownLevel()
"     let line = getline(v:lnum)
"     " if in_code_block doesnt exist, set it to 0
"     if !exists('b:in_code_block')
"         let b:in_code_block = 0
"     endif
"     if line =~ '^##\+\s'
"         let numHashes = len(matchstr(line, '^#\+')) - 1
"         if numHashes >= 1
"             return '>' . numHashes
"         endif
"     endif
"     return '='
" endfunction
" " do the same but ignore # in code blocks
" " ie fix the aboce func

setlocal foldexpr=MarkdownLevel() foldmethod=expr foldlevel=1

" hi markdowncode #39ff14 000000
highlight markdownCode guifg=#39ff14 guibg=#000000
highlight markdownH1   guifg=#FF69FF guibg=#000000 gui=bold

