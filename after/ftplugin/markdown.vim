" vim:ft=vim :wrap
nnoremap <leader>md :MarkdownPreview<cr>
setlocal wrap spell spl=en_us cole=2 fdl=2
let g:vim_markdown_fenced_languages = ['bash=sh', 'python', 'php', 'html', 'c', 'cpp', 'sql', 'vim', 'dockerfile', 'plaintext', 'markdown']
let g:vim_markdown_math = 1

let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_folding_style_pythonic = 1

function! MarkdownLevel()
    if !exists('b:in_code_fence')
        let b:in_code_fence = 0
    endif
    let line = getline(v:lnum)
    let b:in_code_fence = line =~ '^```' ? !b:in_code_fence : b:in_code_fence
    return !b:in_code_fence && matchstr(line, '^\#\+\s') != '' ? '>' . len(matchstr(line, '^\#\+\s')) : '='
endfunction

setlocal foldexpr=MarkdownLevel() foldmethod=expr foldlevel=2
setlocal nosmartindent

" hi markdowncode #39ff14 000000
highlight markdownCode guifg=#39ff14 guibg=#000000
highlight markdownH1   guifg=#FF69FF guibg=#000000
highlight HtmlH1   guifg=#FF69FF guibg=#000000
" make all spellings just red and 000000
highlight SpellBad guifg=red guibg=#000000
highlight SpellCap guifg=red guibg=#000000
highlight SpellLocal guifg=red guibg=#000000
highlight SpellRare guifg=red guibg=#000000
" fix those

