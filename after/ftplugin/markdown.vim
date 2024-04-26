" vim:ft=vim :wrap
nnoremap <leader>md :MarkdownPreview<cr>
setlocal wrap spell spl=en_us cole=2
let g:vim_markdown_fenced_languages = ['bash=sh', 'python', 'php', 'html', 'c', 'cpp', 'sql', 'vim', 'dockerfile', 'plaintext', 'markdown']
let g:vim_markdown_math = 1

" why is this so incredibly annoying?
let g:vim_markdown_folding_disabled = 1

" DIY
function! MarkdownLevel()
    let line = getline(v:lnum)
    let h = matchstr(line, '^#\+')
    if empty(h)
        return "="
    else
        return ">" . len(h)
    endif
endfunction

setlocal fde=MarkdownLevel() fdm=expr fdl=2
